import 'dart:async';
import 'dart:convert';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/messaging/domain/message.dart';
import 'package:atmail/messaging/domain/message_repository.abs.dart';
import 'package:atmail/messaging/domain/message_type.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final logger = Logger('MessageRepositoryImpl');

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl({
    required this.atClient,
    required this.namespace,
  }) {
    _initialize();
  }

  final AtClient atClient;
  final String namespace;

  // Key prefix
  static const String kMsgPrefix = 'msg';

  // Map to store messages by conversation ID
  final Map<String, BehaviorSubject<List<Message>>> _conversationMessages = {};

  // Track which conversations we're currently listening to
  final Set<String> _activeConversations = {};

  StreamSubscription? _notificationSubscription;

  void _initialize() {
    logger.fine('Initializing message repository');
    _startNotificationListener();
  }

  void _startNotificationListener() {
    logger.fine('Setting up message listener');
    _notificationSubscription = atClient.notificationService
        .subscribe(regex: '$kMsgPrefix\\..*\\.$namespace', shouldDecrypt: true)
        .listen((notification) async {
          logger.fine('Received message notification: $notification');
          await _handleNotification(notification);
        });
  }

  Future<void> _handleNotification(AtNotification notification) async {
    try {
      if (notification.key.contains(kMsgPrefix)) {
        String? conversationId = _extractConversationId(notification.key);
        if (conversationId != null) {
          logger.info('Received message notification for conversation: $conversationId');

          // Load the specific message
          await _loadMessage(notification.key, notification.from);
        } else {
          logger.warning('Received message notification with invalid key: ${notification.key}');
        }
      } else {
        logger.warning('Received unknown notification that should have been filtered: ${notification.key}');
      }
    } catch (e, st) {
      logger.severe('Error handling message notification', e, st);
    }
  }

  String? _extractConversationId(String key) {
    // Extract conversation ID from keys like:
    // @bob:msg.conv123abc.1634567890.atmail@alice
    try {
      final parts = key.split('.');
      if (parts.length >= 3 && parts[0].contains(kMsgPrefix)) {
        return parts[1]; // conversation ID is the second part
      }
    } catch (e, st) {
      logger.severe('Error extracting conversation ID from key: $key', e, st);
    }
    return null;
  }

  Future<void> _loadMessage(String messageKey, String fromAtSign) async {
    logger.fine('Loading message with key: $messageKey');
    try {
      AtKey key = AtKey()
        ..key = messageKey
            .split(':')
            .last
            .split('@')
            .first // Extract just the key part
        ..namespace = namespace
        ..sharedBy = fromAtSign
        ..sharedWith = atClient.getCurrentAtSign();

      logger.fine('Loading message with constructed AtKey: $key');

      AtValue value = await atClient.get(key);
      if (value.value != null) {
        Map<String, dynamic> messageData = jsonDecode(value.value);
        Message message = MessageMapper.fromMap(messageData);

        logger.fine('Loaded message: ${message.text}');
        _addMessageToConversation(message);
      }
    } catch (e, st) {
      logger.severe('Error loading message from key: $messageKey', e, st);
    }
  }

  void _addMessageToConversation(Message message) {
    if (!_conversationMessages.containsKey(message.conversationId)) {
      _conversationMessages[message.conversationId] = BehaviorSubject<List<Message>>.seeded([]);
    }

    final currentMessages = List<Message>.from(_conversationMessages[message.conversationId]!.value);

    // Check if message already exists (prevent duplicates)
    final existingIndex = currentMessages.indexWhere((m) => m.timestamp == message.timestamp);

    if (existingIndex >= 0) {
      // Update existing message
      currentMessages[existingIndex] = message;
      logger.fine('Updated existing message');
    } else {
      // Add new message
      currentMessages.add(message);
      logger.fine('Added new message to conversation ${message.conversationId}');
    }

    currentMessages.sort();

    _conversationMessages[message.conversationId]!.add(currentMessages);
  }

  Future<void> _loadConversationMessages(String conversationId) async {
    logger.fine('Loading messages for conversation: $conversationId');

    try {
      // Load messages we've sent
      await _loadSentMessages(conversationId);

      // Load messages others have sent to us
      await _loadReceivedMessages(conversationId);
    } catch (e, st) {
      logger.severe('Error loading conversation messages', e, st);
    }
  }

  Future<void> _loadSentMessages(String conversationId) async {
    logger.fine('Loading sent messages for conversation: $conversationId');

    List<AtKey> sentKeys = await atClient.getAtKeys(
      regex: '^@[^:]+:$kMsgPrefix\\.$conversationId\\..*\\.$namespace@${atClient.getCurrentAtSign()}\$',
    );

    logger.info('Found ${sentKeys.length} sent message keys');

    for (AtKey key in sentKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Map<String, dynamic> messageData = jsonDecode(value.value);
          Message message = MessageMapper.fromMap(messageData);
          _addMessageToConversation(message);
        }
      } catch (e, st) {
        logger.severe('Error loading sent message', e, st);
      }
    }
  }

  Future<void> _loadReceivedMessages(String conversationId) async {
    logger.fine('Loading received messages for conversation: $conversationId');

    List<AtKey> receivedKeys = await atClient.getAtKeys(
      regex: '$kMsgPrefix\\.$conversationId\\..*\\.$namespace',
    );

    logger.info('Found ${receivedKeys.length} received message keys');

    for (AtKey key in receivedKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Map<String, dynamic> messageData = jsonDecode(value.value);
          Message message = MessageMapper.fromMap(messageData);
          _addMessageToConversation(message);
        }
      } catch (e, st) {
        logger.severe('Error loading received message', e, st);
      }
    }
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String message,
    required MessageType type,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.fine('Sending message to conversation: $conversationId');

      DateTime timestamp = DateTime.now();

      // Create message object
      Message messageObj = Message(
        timestamp: timestamp,
        conversationId: conversationId,
        text: message,
        type: type,
        from: atClient.getCurrentAtSign()!,
        to: '', // Will be determined by conversation participants
        metadata: metadata ?? {},
      );

      // Create message key with timestamp for uniqueness
      String messageKey = '$kMsgPrefix.$conversationId.${timestamp.millisecondsSinceEpoch}';

      // TODO: Get conversation participants to send to each one
      // For now, we'll need to determine the recipient(s) from the conversation
      // This would typically involve fetching the conversation details first

      // Get conversation to determine participants
      List<String> participants = await _getConversationParticipants(conversationId);

      // Send message to each participant (except ourselves)
      for (String participant in participants) {
        if (participant != atClient.getCurrentAtSign()) {
          // Update message with specific recipient
          Message participantMessage = messageObj.copyWith(
            to: participant,
          );

          AtKey msgKey =
              (AtKey.shared(
                      messageKey,
                      namespace: namespace,
                    )
                    ..sharedWith(participant)
                    ..cache(-1, true))
                  .build();

          bool stored = await atClient.put(msgKey, jsonEncode(participantMessage.toMap()));

          if (stored) {
            // Send notification
            await atClient.notificationService.notify(
              NotificationParams.forUpdate(msgKey, value: jsonEncode(participantMessage.toMap())),
            );
            logger.info('Message sent to $participant');
          } else {
            logger.severe('Failed to send message to $participant');
          }
        }
      }

      // Add to local messages
      _addMessageToConversation(messageObj);

      return messageObj;
    } catch (e, st) {
      logger.severe('Error sending message', e, st);
      throw Exception('Error sending message: $e');
    }
  }

  Future<List<String>> _getConversationParticipants(String conversationId) async {
    // TODO: This should fetch the conversation details and return participants
    // For now, this is a placeholder that would need to be implemented
    // based on how conversations are stored and accessed

    // This method would typically:
    // 1. Fetch the conversation using the conversationId
    // 2. Extract the participants list
    // 3. Return the list

    logger.warning('_getConversationParticipants not fully implemented');
    return []; // Placeholder
  }

  @override
  Stream<List<Message>> fetchMessages({
    required String conversationId,
  }) {
    logger.fine('Fetching messages for conversation: $conversationId');

    // Initialize conversation stream if it doesn't exist
    if (!_conversationMessages.containsKey(conversationId)) {
      _conversationMessages[conversationId] = BehaviorSubject<List<Message>>.seeded([]);
    }

    // Load messages if this is the first time accessing this conversation
    if (!_activeConversations.contains(conversationId)) {
      _activeConversations.add(conversationId);
      _loadConversationMessages(conversationId);
    }

    return _conversationMessages[conversationId]!.stream;
  }

  @override
  Future<bool> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      logger.fine('Deleting message: $messageId from conversation: $conversationId');

      // Parse timestamp from messageId (assuming messageId is timestamp in milliseconds)
      int timestamp = int.parse(messageId);

      // Create message key
      String messageKey = '$kMsgPrefix.$conversationId.$timestamp';

      // Get conversation participants to delete from each one
      List<String> participants = await _getConversationParticipants(conversationId);

      bool allDeleted = true;

      // Delete message for each participant
      for (String participant in participants) {
        if (participant != atClient.getCurrentAtSign()) {
          AtKey msgKey = AtKey()
            ..key = messageKey
            ..namespace = namespace
            ..sharedWith = participant
            ..sharedBy = atClient.getCurrentAtSign();

          try {
            await atClient.delete(msgKey);
            logger.fine('Message deleted for participant: $participant');
          } catch (e) {
            logger.severe('Failed to delete message for participant: $participant', e);
            allDeleted = false;
          }
        }
      }

      if (allDeleted) {
        // Remove from local messages
        if (_conversationMessages.containsKey(conversationId)) {
          final currentMessages = List<Message>.from(_conversationMessages[conversationId]!.value);

          currentMessages.removeWhere((m) => m.timestamp.millisecondsSinceEpoch.toString() == messageId);

          _conversationMessages[conversationId]!.add(currentMessages);
          logger.info('Message removed from local storage');
        }
      }

      return allDeleted;
    } catch (e, st) {
      logger.severe('Error deleting message', e, st);
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    logger.fine('Disposing message repository');

    _notificationSubscription?.cancel();

    // Close all conversation streams
    for (final subject in _conversationMessages.values) {
      await subject.close();
    }

    _conversationMessages.clear();
    _activeConversations.clear();
  }
}
