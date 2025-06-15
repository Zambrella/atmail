import 'dart:async';
import 'dart:convert';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/domain/app_message.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:atmail/messaging/domain/message_status.dart';
import 'package:atmail/messaging/repository/conversation.dart';
import 'package:atmail/messaging/repository/message.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

final logger = Logger('AppConversationRepositoryImpl');

class AppConversationRepositoryImpl implements AppConversationRepository {
  AppConversationRepositoryImpl({
    required this.atClient,
    required this.namespace,
  }) {
    _initialize();
  }

  final AtClient atClient;
  final String namespace;

  // Key prefixes
  static const String kConvPrefix = 'conv';
  static const String kConvIndexPrefix = 'conv_index';
  static const String kMsgPrefix = 'msg';

  // Single source of truth for all conversations
  final BehaviorSubject<List<AppConversation>> _conversations = BehaviorSubject<List<AppConversation>>.seeded([]);

  StreamSubscription? _conversationNotificationSubscription;
  StreamSubscription? _messageNotificationSubscription;
  Timer? _periodicRefresh;

  void _initialize() {
    logger.fine('Initializing app conversation repository');

    // Listen for real-time notifications
    _startNotificationListeners();

    // Initial load of conversations
    _loadAllConversations();

    // Periodic refresh to catch any missed conversations
    _periodicRefresh = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshConversations();
    });
  }

  void _startNotificationListeners() {
    logger.fine('Setting up notification listeners');

    // Listen for conversation notifications
    final conversationRegex = RegExp('$kConvPrefix\\..*\\.$namespace');
    _conversationNotificationSubscription = atClient.notificationService
        .subscribe(regex: conversationRegex.pattern, shouldDecrypt: true)
        .listen((notification) async {
          logger.fine('Received conversation notification: $notification');
          await _handleConversationNotification(notification);
        });

    // Listen for message notifications
    final messageRegex = RegExp('$kMsgPrefix\\..*\\.$namespace');
    _messageNotificationSubscription = atClient.notificationService
        .subscribe(regex: messageRegex.pattern, shouldDecrypt: true)
        .listen((notification) async {
          logger.fine('Received message notification: $notification');
          await _handleMessageNotification(notification);
        });
  }

  // Helper methods to work with the single source of truth
  AppConversation? _getConversation(String id) => _conversations.value.firstWhereOrNull((c) => c.id == id);

  bool _hasConversation(String id) => _conversations.value.any((c) => c.id == id);

  void _addOrUpdateConversation(AppConversation conversation) {
    final current = List<AppConversation>.from(_conversations.value);
    final index = current.indexWhere((c) => c.id == conversation.id);

    if (index >= 0) {
      current[index] = conversation;
    } else {
      current.add(conversation);
    }

    current.sort(); // Keep sorted by most recent
    _conversations.add(current);
  }

  void _removeConversation(String conversationId) {
    final current = List<AppConversation>.from(_conversations.value);
    current.removeWhere((c) => c.id == conversationId);
    _conversations.add(current);
  }

  void _addMessageToConversation(String conversationId, AppMessage message) {
    final current = List<AppConversation>.from(_conversations.value);
    final index = current.indexWhere((c) => c.id == conversationId);

    if (index >= 0) {
      final conversation = current[index];
      final updatedMessages = List<AppMessage>.from(conversation.messages);

      // Check if message already exists
      final existingIndex = updatedMessages.indexWhere(
        (m) => m.timestamp == message.timestamp && m.sender == message.sender,
      );

      if (existingIndex >= 0) {
        updatedMessages[existingIndex] = message;
      } else {
        updatedMessages.add(message);
      }

      updatedMessages.sort();

      current[index] = conversation.copyWith(messages: updatedMessages);
      current.sort(); // Re-sort conversations
      _conversations.add(current);
    } else {
      logger.warning('Conversation with ID $conversationId not found');
    }
  }

  // Converter functions
  AppConversation _convertToAppConversation(Conversation conversation, List<AppMessage> messages) {
    return AppConversation(
      id: conversation.id,
      subject: conversation.subject,
      participants: conversation.participants,
      createdAt: conversation.createdAt,
      createdBy: conversation.createdBy,
      messages: messages,
      metadata: conversation.metadata,
    );
  }

  Conversation _convertFromAppConversation(AppConversation appConversation) {
    return Conversation(
      id: appConversation.id,
      subject: appConversation.subject,
      participants: appConversation.participants,
      createdAt: appConversation.createdAt,
      createdBy: appConversation.createdBy,
      metadata: appConversation.metadata,
    );
  }

  AppMessage _convertToAppMessage(Message message) {
    return AppMessage(
      timestamp: message.timestamp,
      content: message.content,
      sender: message.from,
      // _convertToAppMessage is only called when fetching messages from the server and for them to exist they must be
      // sent and delivered.
      status: MessageStatusDelivered(),
      metadata: message.metadata,
    );
  }

  Message _convertFromAppMessage(AppMessage appMessage, String conversationId, String recipient) {
    return Message(
      timestamp: appMessage.timestamp,
      conversationId: conversationId,
      content: appMessage.content,
      from: appMessage.sender,
      to: recipient,
      metadata: appMessage.metadata,
    );
  }

  Future<void> _handleConversationNotification(AtNotification notification) async {
    try {
      if (notification.key.contains(kConvPrefix)) {
        String? conversationId = _extractConversationId(notification.key);
        if (conversationId != null && notification.value != null) {
          // Notification value needs to be used as the data might not be in the server yet.
          final conversation = ConversationMapper.fromJson(notification.value!);
          List<AppMessage> messages = await _loadConversationMessages(conversationId);
          AppConversation appConversation = _convertToAppConversation(conversation, messages);
          _addOrUpdateConversation(appConversation);
        } else if (conversationId != null && notification.operation == 'delete') {
          await _removeFromConversationIndex(conversationId);
          _removeConversation(conversationId);
        } else {
          logger.warning('Invalid conversation notification: $notification');
        }
      }
    } catch (e, st) {
      logger.severe('Error handling conversation notification', e, st);
    }
  }

  Future<void> _handleMessageNotification(AtNotification notification) async {
    try {
      if (notification.key.contains(kMsgPrefix)) {
        String? conversationId = _extractConversationIdFromMessageKey(notification.key);
        if (conversationId != null && notification.value != null) {
          Message message = MessageMapper.fromJson(notification.value!);
          AppMessage appMessage = _convertToAppMessage(message);
          _addMessageToConversation(conversationId, appMessage);
        } else if (conversationId != null && notification.operation == 'delete') {
          // What if the conversation is deleted before the messages?
          final conversation = _getConversation(conversationId);
          final messageId = _extractMessageIdFromMessageKey(notification.key);
          final updatedMessages = List<AppMessage>.from(conversation!.messages)
            ..removeWhere((m) => m.timestamp.millisecondsSinceEpoch.toString() == messageId);
          final updatedConversation = conversation.copyWith(messages: updatedMessages);
          _addOrUpdateConversation(updatedConversation);
        } else {
          logger.warning('Invalid message notification: $notification');
        }
      }
    } catch (e, st) {
      logger.severe('Error handling message notification', e, st);
    }
  }

  String? _extractConversationId(String key) {
    try {
      final parts = key.split('.');
      if (parts.length >= 2 && parts[0].contains(kConvPrefix)) {
        return parts[1];
      }
    } catch (e, st) {
      logger.severe('Error extracting conversation ID', e, st);
    }
    return null;
  }

  String? _extractConversationIdFromMessageKey(String key) {
    try {
      final parts = key.split('.');
      if (parts.length >= 3 && parts[0].contains(kMsgPrefix)) {
        return parts[1]; // conversation ID is the second part
      }
    } catch (e, st) {
      logger.severe('Error extracting conversation ID from message key: $key', e, st);
    }
    return null;
  }

  String? _extractMessageIdFromMessageKey(String key) {
    try {
      final parts = key.split('.');
      if (parts.length >= 3 && parts[0].contains(kMsgPrefix)) {
        return parts[2]; // message ID is the third part
      }
    } catch (e, st) {
      logger.severe('Error extracting messageID from message key: $key', e, st);
    }
    return null;
  }

  Future<void> _loadAllConversations() async {
    logger.fine('Loading all conversations');
    try {
      // Load conversations we've created
      await _loadSentConversations();

      // Load conversations others have started with us
      await _loadReceivedConversations();

      // Check conversation index
      await _loadFromConversationIndex();
    } catch (e, st) {
      logger.severe('Error loading all conversations', e, st);
    }
  }

  Future<void> _loadSentConversations() async {
    logger.fine('Loading sent conversations');
    final regex = RegExp('$kConvPrefix\\..*\\.$namespace');
    List<AtKey> convKeys = await atClient.getAtKeys(
      regex: regex.pattern,
    );

    logger.finer('Found ${convKeys.length} sent conversation keys');

    for (AtKey key in convKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Conversation conversation = ConversationMapper.fromJson(value.value);
          String conversationId = conversation.id;

          if (!_hasConversation(conversationId)) {
            // Load messages for this conversation
            List<AppMessage> messages = await _loadConversationMessages(conversationId);

            AppConversation appConversation = _convertToAppConversation(conversation, messages);
            _addOrUpdateConversation(appConversation);

            logger.fine('Loaded sent conversation: $conversationId');
          }
        }
      } catch (e, st) {
        logger.severe('Error loading sent conversation', e, st);
      }
    }
  }

  Future<void> _loadReceivedConversations() async {
    logger.fine('Loading received conversations');
    final regex = RegExp('cached:.*$kConvPrefix\\..*\\.$namespace');
    List<AtKey> receivedKeys = await atClient.getAtKeys(
      regex: regex.pattern,
    );

    logger.finer('Found ${receivedKeys.length} received conversation keys');

    for (AtKey key in receivedKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Conversation conversation = ConversationMapper.fromJson(value.value);
          String conversationId = conversation.id;

          if (!_hasConversation(conversationId)) {
            // Load messages for this conversation
            List<AppMessage> messages = await _loadConversationMessages(conversationId);

            AppConversation appConversation = _convertToAppConversation(conversation, messages);
            _addOrUpdateConversation(appConversation);

            logger.fine('Loaded received conversation: $conversationId');
          }
        }
      } catch (e, st) {
        logger.severe('Error loading received conversation', e, st);
      }
    }
  }

  Future<void> _loadFromConversationIndex() async {
    logger.fine('Loading conversation index');
    try {
      final regex = RegExp(
        '^(@${atClient.getCurrentAtSign()}:|cached:@${atClient.getCurrentAtSign()}:)$kConvIndexPrefix\\.$namespace@.*',
      );
      List<AtKey> indexKeys = await atClient.getAtKeys(
        regex: regex.pattern,
      );

      for (AtKey indexKey in indexKeys) {
        try {
          AtValue indexValue = await atClient.get(indexKey);
          if (indexValue.value != null) {
            List<String> conversationIds = List<String>.from(jsonDecode(indexValue.value));

            for (String convId in conversationIds) {
              if (!_hasConversation(convId)) {
                await _loadConversation(convId);
              }
            }
          }
        } catch (e, st) {
          logger.severe('Error loading from index', e, st);
        }
      }
    } catch (e, st) {
      logger.severe('Error loading conversation indices', e, st);
    }
  }

  Future<void> _loadConversation(String conversationId) async {
    logger.fine('Loading conversation $conversationId');
    try {
      AtKey convKey = AtKey()
        ..key = '$kConvPrefix.$conversationId'
        ..namespace = namespace
        ..sharedWith = atClient.getCurrentAtSign();

      AtValue value = await atClient.get(convKey);
      if (value.value != null) {
        if (!_hasConversation(conversationId)) {
          Conversation conversation = ConversationMapper.fromJson(value.value);

          // Load messages for this conversation
          List<AppMessage> messages = await _loadConversationMessages(conversationId);

          AppConversation appConversation = _convertToAppConversation(conversation, messages);
          _addOrUpdateConversation(appConversation);
        }
      }
    } catch (e, stackTrace) {
      logger.severe('Error loading conversation $conversationId: $e', e, stackTrace);
    }
  }

  Future<List<AppMessage>> _loadConversationMessages(String conversationId) async {
    logger.fine('Loading messages for conversation: $conversationId');

    List<AppMessage> messages = [];

    try {
      // Load messages we've sent
      messages.addAll(await _loadSentMessages(conversationId));

      // Load messages others have sent to us
      messages.addAll(await _loadReceivedMessages(conversationId));

      // Sort messages by timestamp
      messages.sort();

      // Remove duplicates based on timestamp and sender
      final uniqueMessages = <String, AppMessage>{};
      for (final message in messages) {
        final key = '${message.timestamp.millisecondsSinceEpoch}_${message.sender}';
        uniqueMessages[key] = message;
      }

      return uniqueMessages.values.toList()..sort();
    } catch (e, st) {
      logger.severe('Error loading conversation messages', e, st);
      return [];
    }
  }

  Future<List<AppMessage>> _loadSentMessages(String conversationId) async {
    logger.fine('Loading sent messages for conversation: $conversationId');

    List<AppMessage> messages = [];
    final regex = RegExp('$kMsgPrefix\\.$conversationId\\..*\\.$namespace');
    List<AtKey> sentKeys = await atClient.getAtKeys(
      regex: regex.pattern,
    );

    for (AtKey key in sentKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Message message = MessageMapper.fromJson(value.value);
          messages.add(_convertToAppMessage(message));
        }
      } catch (e, st) {
        logger.severe('Error loading sent message', e, st);
      }
    }

    return messages;
  }

  Future<List<AppMessage>> _loadReceivedMessages(String conversationId) async {
    logger.fine('Loading received messages for conversation: $conversationId');

    List<AppMessage> messages = [];
    final regex = RegExp('cached:.*$kMsgPrefix\\.$conversationId\\..*\\.$namespace');
    List<AtKey> receivedKeys = await atClient.getAtKeys(
      regex: regex.pattern,
    );

    for (AtKey key in receivedKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Message message = MessageMapper.fromJson(value.value);
          messages.add(_convertToAppMessage(message));
        }
      } catch (e, st) {
        logger.severe('Error loading received message', e, st);
      }
    }

    return messages;
  }

  Future<void> _loadMessage(String messageKey, String fromAtSign, String conversationId) async {
    logger.fine('Loading message with key: $messageKey');
    try {
      AtKey key = AtKey()
        ..key = messageKey.split(':').last.split('@').first
        ..namespace = namespace
        ..sharedBy = fromAtSign
        ..sharedWith = atClient.getCurrentAtSign();

      AtValue value = await atClient.get(key);
      if (value.value != null) {
        Message message = MessageMapper.fromJson(value.value);
        AppMessage appMessage = _convertToAppMessage(message);

        _addMessageToConversation(conversationId, appMessage);
      }
    } catch (e, st) {
      logger.severe('Error loading message from key: $messageKey', e, st);
    }
  }

  Future<void> _refreshConversations() async {
    await _loadReceivedConversations();
  }

  Future<void> _updateConversationIndex(String conversationId) async {
    logger.fine('Updating conversation $conversationId index');
    try {
      AtKey indexKey = AtKey()
        ..key = kConvIndexPrefix
        ..namespace = namespace
        ..metadata = Metadata()
        ..metadata.isPublic = false;

      List<String> conversationIds = [];

      try {
        AtValue existing = await atClient.get(indexKey);
        if (existing.value != null) {
          conversationIds = List<String>.from(jsonDecode(existing.value));
        }
      } catch (e) {
        // Index doesn't exist yet
      }

      if (!conversationIds.contains(conversationId)) {
        conversationIds.add(conversationId);
        await atClient.put(indexKey, jsonEncode(conversationIds));
      }
    } catch (e, st) {
      logger.severe('Error updating conversation index', e, st);
    }
  }

  Future<void> _removeFromConversationIndex(String conversationId) async {
    logger.info('Removing conversation from index');
    try {
      AtKey indexKey = AtKey()
        ..key = kConvIndexPrefix
        ..namespace = namespace;

      AtValue existing = await atClient.get(indexKey);
      if (existing.value != null) {
        List<String> conversationIds = List<String>.from(jsonDecode(existing.value));
        conversationIds.remove(conversationId);
        await atClient.put(indexKey, jsonEncode(conversationIds));
      }
    } catch (e, st) {
      logger.warning('Error removing from conversation index', e, st);
    }
  }

  @override
  Future<AppConversation> startConversation({
    required String withAtSign,
    required String initialMessage,
    required String subject,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.fine('Starting conversation with $withAtSign');

      String conversationId = Uuid().v4();
      DateTime now = DateTime.now();

      // Create conversation
      AppConversation appConversation = AppConversation(
        id: conversationId,
        subject: subject,
        participants: [atClient.getCurrentAtSign()!, withAtSign],
        createdAt: now,
        createdBy: atClient.getCurrentAtSign()!,
        messages: [],
        metadata: metadata ?? {},
      );

      // Convert to storage model
      Conversation conversation = _convertFromAppConversation(appConversation);
      Map<String, dynamic> convData = conversation.toMap();

      // Create shared key for the conversation
      AtKey convKey =
          (AtKey.shared(
                  '$kConvPrefix.$conversationId',
                  namespace: namespace,
                )
                ..sharedWith(withAtSign)
                // Conversation metadata should always be available to those that have been invited so setting
                // ccd to false.
                ..cache(-1, false))
              .build();

      // Store conversation data
      bool stored = await atClient.put(convKey, jsonEncode(convData));

      logger.fine('Conversation stored using key: $convKey. Conversation data: $convData');

      if (stored) {
        // Send notification
        await atClient.notificationService.notify(
          NotificationParams.forUpdate(convKey, value: jsonEncode(convData)),
        );

        // Update local index
        await _updateConversationIndex(conversationId);

        // Add to local state
        _addOrUpdateConversation(appConversation);

        // Send the initial message
        await sendMessage(
          conversationId: conversationId,
          content: TextContent(initialMessage),
        );

        return appConversation;
      } else {
        throw Exception('Failed to create conversation');
      }
    } catch (e, st) {
      logger.severe('Error starting conversation', e, st);
      throw Exception('Error starting conversation: $e');
    }
  }

  @override
  Future<AppConversation> startGroupConversation({
    required List<String> withAtSigns,
    required String initialMessage,
    required String subject,
    String? groupName,
    Map<String, dynamic>? metadata,
  }) async {
    logger.fine('Starting group conversation with $withAtSigns');
    try {
      String conversationId = Uuid().v4();
      DateTime now = DateTime.now();

      // Include current user in participants
      List<String> allParticipants = [atClient.getCurrentAtSign()!, ...withAtSigns];

      // Add group name to metadata if provided
      Map<String, dynamic> convMetadata = metadata ?? {};
      if (groupName != null) {
        convMetadata['groupName'] = groupName;
      }

      AppConversation appConversation = AppConversation(
        id: conversationId,
        subject: subject,
        participants: allParticipants,
        createdAt: now,
        createdBy: atClient.getCurrentAtSign()!,
        messages: [],
        metadata: convMetadata,
      );

      // Convert to storage model
      Conversation conversation = _convertFromAppConversation(appConversation);
      Map<String, dynamic> convData = conversation.toMap();

      // Share conversation with each participant
      for (String participant in withAtSigns) {
        AtKey convKey =
            (AtKey.shared(
                    '$kConvPrefix.$conversationId',
                    namespace: namespace,
                  )
                  ..sharedWith(participant)
                  // Conversation metadata should always be available to those that have been invited so setting
                  // ccd to false.
                  ..cache(-1, false))
                .build();

        await atClient.put(convKey, jsonEncode(convData));

        // Notify each participant
        await atClient.notificationService.notify(
          NotificationParams.forUpdate(convKey, value: jsonEncode(convData)),
        );
      }

      // Update local index
      await _updateConversationIndex(conversationId);

      // Add to local state
      _addOrUpdateConversation(appConversation);

      // Send the initial message
      await sendMessage(
        conversationId: conversationId,
        content: TextContent(initialMessage),
      );

      return appConversation;
    } catch (e, st) {
      logger.severe('Error starting group conversation', e, st);
      throw Exception('Error starting group conversation: $e');
    }
  }

  @override
  Stream<List<AppConversation>> getConversations() {
    // Direct access to the stream - no transformation needed!
    return _conversations.stream;
  }

  @override
  Future<void> leaveConversation(String conversationId) async {
    logger.fine('Leaving conversation $conversationId');
    try {
      // Find the conversation
      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      // Verify caller is the creator
      if (conversation.createdBy != atClient.getCurrentAtSign()) {
        throw Exception('Only the conversation creator can delete it');
      }

      // Delete shared keys for each participant
      for (String participant in conversation.participants) {
        if (participant != atClient.getCurrentAtSign()) {
          AtKey convKey = AtKey()
            ..key = '$kConvPrefix.$conversationId'
            ..namespace = namespace
            ..sharedWith = participant
            ..sharedBy = atClient.getCurrentAtSign();

          final success = await atClient.delete(convKey);
          if (success) {
            logger.info('Successfully deleted conversation key: $convKey');
          } else {
            logger.warning('Failed to delete conversation key: $convKey');
          }

          await atClient.notificationService.notify(
            NotificationParams.forDelete(convKey),
          );

          // Also delete all messages
          final regex = RegExp(
            '$kMsgPrefix\\.$conversationId',
          );
          List<AtKey> messageKeys = await atClient.getAtKeys(
            regex: regex.pattern,
          );

          logger.fine('Message keys for deletion: $messageKeys');

          for (AtKey msgKey in messageKeys) {
            final success = await atClient.delete(msgKey);
            if (success) {
              logger.fine('Successfully deleted message key: $msgKey');
            } else {
              logger.warning('Failed to delete message key: $msgKey');
            }
            await atClient.notificationService.notify(
              NotificationParams.forDelete(msgKey),
            );
          }
        }
      }

      // Remove from conversation index
      await _removeFromConversationIndex(conversationId);

      // Remove from local state
      _removeConversation(conversationId);
    } catch (e, st) {
      logger.severe('Error deleting conversation', e, st);
      throw Exception('Error deleting conversation: $e');
    }
  }

  @override
  Future<AppMessage> sendMessage({
    required String conversationId,
    required MessageContent content,
  }) async {
    final message = AppMessage(
      timestamp: DateTime.now(),
      content: content,
      status: MessageStatusPending(),
      sender: atClient.getCurrentAtSign()!,
    );

    try {
      logger.fine('Sending message to conversation: $conversationId');

      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      _addMessageToConversation(conversationId, message);

      // Create message key with timestamp for uniqueness
      String messageKey = '$kMsgPrefix.$conversationId.${message.timestamp.millisecondsSinceEpoch}';

      // Send message to each participant (except ourselves)
      for (String participant in conversation.participants) {
        if (participant != atClient.getCurrentAtSign()) {
          // Convert to storage model
          Message storageMessage = _convertFromAppMessage(message, conversationId, participant);

          AtKey msgKey =
              (AtKey.shared(
                      messageKey,
                      namespace: namespace,
                    )
                    ..sharedWith(participant)
                    ..cache(-1, true))
                  .build();

          bool stored = await atClient.put(msgKey, jsonEncode(storageMessage.toMap()));

          _addMessageToConversation(conversationId, message.copyWith(status: MessageStatusSent()));

          if (stored) {
            // Send notification
            await atClient.notificationService.notify(
              NotificationParams.forUpdate(msgKey, value: jsonEncode(storageMessage.toMap())),
            );
            _addMessageToConversation(conversationId, message.copyWith(status: MessageStatusDelivered()));
            logger.info('Message sent to $participant');
          }
        }
      }

      return message;
    } catch (e, st) {
      _addMessageToConversation(
        conversationId,
        message.copyWith(
          status: MessageStatusError(
            'Failed to send message: $message',
            e is Exception ? e : Exception(e.toString()),
          ),
        ),
      );
      logger.severe('Error sending message', e, st);
      throw Exception('Error sending message: $e');
    }
  }

  @override
  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
    bool quietly = false,
  }) async {
    try {
      logger.fine('Deleting message: $messageId from conversation: $conversationId');

      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      // Find the message
      final message = conversation.messages.firstWhereOrNull(
        (m) => m.timestamp.millisecondsSinceEpoch.toString() == messageId,
      );

      if (message == null) {
        throw Exception('Message not found');
      }

      // Verify caller is the sender
      if (message.sender != atClient.getCurrentAtSign()) {
        throw Exception('Only the message sender can delete it');
      }

      // Parse timestamp from messageId
      int timestamp = int.parse(messageId);

      // Create message key
      String messageKey = '$kMsgPrefix.$conversationId.$timestamp';

      // Delete message for each participant
      for (String participant in conversation.participants) {
        if (participant != atClient.getCurrentAtSign()) {
          AtKey msgKey = AtKey()
            ..key = messageKey
            ..namespace = namespace
            ..sharedWith = participant
            ..sharedBy = atClient.getCurrentAtSign();

          final success = await atClient.delete(msgKey);
          if (success) {
            logger.fine('Successfully deleted message key: $msgKey');
          } else {
            logger.warning('Failed to delete message key: $msgKey');
          }
          await atClient.notificationService.notify(
            NotificationParams.forDelete(msgKey),
          );
        }
      }

      // Remove from local state
      final updatedMessages = List<AppMessage>.from(conversation.messages)
        ..removeWhere((m) => m.timestamp.millisecondsSinceEpoch.toString() == messageId);

      final updatedConversation = conversation.copyWith(messages: updatedMessages);
      _addOrUpdateConversation(updatedConversation);
    } catch (e, st) {
      logger.severe('Error deleting message', e, st);
      throw Exception('Error deleting message: $e');
    }
  }

  @override
  Future<void> dispose() async {
    logger.fine('Disposing app conversation repository');

    _conversationNotificationSubscription?.cancel();
    _messageNotificationSubscription?.cancel();
    _periodicRefresh?.cancel();
    await _conversations.close();
  }
}
