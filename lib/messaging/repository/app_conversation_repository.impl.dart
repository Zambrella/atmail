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

final _log = Logger('AppConversationRepositoryImpl');

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
  static const String kMsgPrefix = 'msg';
  static const String kStatusPrefix = 'status';
  static const String kArchivedSuffix = 'archived';

  // Single source of truth for all conversations
  final BehaviorSubject<List<AppConversation>> _conversations = BehaviorSubject<List<AppConversation>>.seeded([]);

  StreamSubscription? _conversationNotificationSubscription;
  StreamSubscription? _messageNotificationSubscription;
  Timer? _periodicRefresh;

  void _initialize() {
    _log.fine('Initializing app conversation repository');

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
    _log.fine('Setting up notification listeners');

    // Listen for conversation notifications
    final conversationRegex = RegExp('$kConvPrefix\\.[^.]+\\.$namespace');
    _conversationNotificationSubscription = atClient.notificationService
        .subscribe(regex: conversationRegex.pattern, shouldDecrypt: true)
        .listen((notification) async {
          _log.fine('Received conversation notification: $notification');
          await _handleConversationNotification(notification);
        });

    // Listen for message notifications
    final messageRegex = RegExp('$kConvPrefix\\.[^.]+\\.$kMsgPrefix\\..*\\.$namespace');
    _messageNotificationSubscription = atClient.notificationService
        .subscribe(regex: messageRegex.pattern, shouldDecrypt: true)
        .listen((notification) async {
          _log.fine('Received message notification: $notification');
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
      _log.warning('Conversation with ID $conversationId not found');
    }
  }

  // Converter functions
  Future<AppConversation> _convertToAppConversation(Conversation conversation, List<AppMessage> messages) async {
    // Check if conversation is archived
    bool isArchived = await _isConversationArchived(conversation.id);
    final hasLeft = await _hasParticipantLeft(conversation.id, atClient.getCurrentAtSign()!);

    return AppConversation(
      id: conversation.id,
      subject: conversation.subject,
      participants: conversation.participants,
      createdAt: conversation.createdAt,
      createdBy: conversation.createdBy,
      messages: messages,
      isArchived: isArchived,
      hasLeft: hasLeft,
      metadata: conversation.metadata,
    );
  }

  Future<bool> _isConversationArchived(String conversationId) async {
    try {
      AtKey archivedKey = AtKey()
        ..key = '$kConvPrefix.$conversationId.$kArchivedSuffix'
        ..namespace = namespace;

      AtValue existing = await atClient.get(archivedKey);
      return existing.value != null;
    } catch (e) {
      // Key doesn't exist, not archived
      return false;
    }
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
          AppConversation appConversation = await _convertToAppConversation(conversation, messages);
          _addOrUpdateConversation(appConversation);
        } else if (conversationId != null && notification.operation == 'delete') {
          _removeConversation(conversationId);
        } else {
          _log.warning('Invalid conversation notification: $notification');
        }
      }
    } catch (e, st) {
      _log.severe('Error handling conversation notification', e, st);
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
          _log.warning('Invalid message notification: $notification');
        }
      }
    } catch (e, st) {
      _log.severe('Error handling message notification', e, st);
    }
  }

  String? _extractConversationId(String key) {
    try {
      final parts = key.split('.');
      if (parts.length >= 2 && parts[0].contains(kConvPrefix)) {
        return parts[1];
      }
    } catch (e, st) {
      _log.severe('Error extracting conversation ID', e, st);
    }
    return null;
  }

  String? _extractConversationIdFromMessageKey(String key) {
    try {
      final parts = key.split('.');
      if (parts.length >= 3 && parts[2].contains(kMsgPrefix)) {
        return parts[1]; // conversation ID is the second part
      }
    } catch (e, st) {
      _log.severe('Error extracting conversation ID from message key: $key', e, st);
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
      _log.severe('Error extracting messageID from message key: $key', e, st);
    }
    return null;
  }

  Future<void> _loadAllConversations() async {
    _log.fine('Loading all conversations');
    try {
      // Load conversations we've created
      await _loadSentConversations();

      // Load conversations others have started with us
      await _loadReceivedConversations();
    } catch (e, st) {
      _log.severe('Error loading all conversations', e, st);
    }
  }

  Future<void> _loadSentConversations() async {
    _log.fine('Loading sent conversations');
    final regex = RegExp('$kConvPrefix\\.[^.]+\\.$namespace');
    List<AtKey> convKeys = await atClient.getAtKeys(
      regex: regex.pattern,
    );

    _log.fine('Found ${convKeys.length} sent conversation keys');

    for (AtKey key in convKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Conversation conversation = ConversationMapper.fromJson(value.value);
          String conversationId = conversation.id;

          if (!_hasConversation(conversationId)) {
            // Load messages for this conversation
            List<AppMessage> messages = await _loadConversationMessages(conversationId);

            AppConversation appConversation = await _convertToAppConversation(conversation, messages);
            _addOrUpdateConversation(appConversation);

            _log.fine('Loaded sent conversation: $conversationId');
          }
        }
      } catch (e, st) {
        _log.severe('Error loading sent conversation', e, st);
      }
    }
  }

  Future<void> _loadReceivedConversations() async {
    _log.fine('Loading received conversations');
    final regex = RegExp('cached:.*$kConvPrefix\\.[^.]+\\.$namespace');
    List<AtKey> receivedKeys = await atClient.getAtKeys(
      regex: regex.pattern,
    );

    _log.finer('Found ${receivedKeys.length} received conversation keys');

    for (AtKey key in receivedKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Conversation conversation = ConversationMapper.fromJson(value.value);
          String conversationId = conversation.id;

          if (!_hasConversation(conversationId)) {
            // Load messages for this conversation
            List<AppMessage> messages = await _loadConversationMessages(conversationId);

            AppConversation appConversation = await _convertToAppConversation(conversation, messages);
            _addOrUpdateConversation(appConversation);

            _log.fine('Loaded received conversation: $conversationId');
          }
        }
      } catch (e, st) {
        _log.severe('Error loading received conversation', e, st);
      }
    }
  }

  Future<List<AppMessage>> _loadConversationMessages(String conversationId) async {
    _log.fine('Loading messages for conversation: $conversationId');

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
      _log.severe('Error loading conversation messages', e, st);
      return [];
    }
  }

  Future<List<AppMessage>> _loadSentMessages(String conversationId) async {
    _log.fine('Loading sent messages for conversation: $conversationId');

    List<AppMessage> messages = [];
    final regex = RegExp('$kConvPrefix\\.$conversationId\\.$kMsgPrefix\\..*\\.$namespace');
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
        _log.severe('Error loading sent message', e, st);
      }
    }

    return messages;
  }

  Future<List<AppMessage>> _loadReceivedMessages(String conversationId) async {
    _log.fine('Loading received messages for conversation: $conversationId');

    List<AppMessage> messages = [];
    final regex = RegExp('cached:.*$kConvPrefix\\.$conversationId\\.$kMsgPrefix\\..*\\.$namespace');
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
        _log.severe('Error loading received message', e, st);
      }
    }

    return messages;
  }

  Future<void> _refreshConversations() async {
    await _loadReceivedConversations();
  }

  Future<void> _updateArchivedStatus(String conversationId, bool isArchived) async {
    _log.fine('Updating archived status for conversation $conversationId');
    try {
      AtKey archivedKey = AtKey()
        ..key = '$kConvPrefix.$conversationId.$kArchivedSuffix'
        ..namespace = namespace
        ..metadata = Metadata()
        ..metadata.isPublic = false;

      if (isArchived) {
        await atClient.put(archivedKey, DateTime.now().toIso8601String());
      } else {
        await atClient.delete(archivedKey);
      }
    } catch (e, st) {
      _log.severe('Error updating archived status', e, st);
    }
  }

  Future<bool> _hasParticipantLeft(String conversationId, String participant) async {
    try {
      final statusKey = '$kStatusPrefix.$conversationId';
      AtKey statusAtKey = AtKey()
        ..key = statusKey
        ..namespace = namespace
        ..sharedBy = participant
        ..sharedWith = atClient.getCurrentAtSign();

      AtValue statusValue = await atClient.get(statusAtKey);
      if (statusValue.value != null) {
        final statusData = jsonDecode(statusValue.value);
        return statusData['status'] == 'left';
      }
      return false;
    } catch (e) {
      // Key doesn't exist, assume they haven't left
      return false;
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
      _log.fine('Starting conversation with $withAtSign');

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

      _log.fine('Conversation stored using key: $convKey. Conversation data: $convData');

      if (stored) {
        // Send notification
        await atClient.notificationService.notify(
          NotificationParams.forUpdate(convKey, value: jsonEncode(convData)),
        );

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
      _log.severe('Error starting conversation', e, st);
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
    _log.fine('Starting group conversation with $withAtSigns');
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

      // Add to local state
      _addOrUpdateConversation(appConversation);

      // Send the initial message
      await sendMessage(
        conversationId: conversationId,
        content: TextContent(initialMessage),
      );

      return appConversation;
    } catch (e, st) {
      _log.severe('Error starting group conversation', e, st);
      throw Exception('Error starting group conversation: $e');
    }
  }

  @override
  Stream<List<AppConversation>> getConversations() {
    // Direct access to the stream - no transformation needed!
    return _conversations.stream;
  }

  @override
  Future<List<AppConversation>> getArchivedConversations() async {
    _log.fine('Getting archived conversations');
    final currentConversations = _conversations.value;
    return currentConversations.where((conversation) => conversation.isArchived).toList();
  }

  @override
  Future<void> archiveConversation(String conversationId) async {
    _log.fine('Archiving conversation $conversationId');
    try {
      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      // Update archived status
      await _updateArchivedStatus(conversationId, true);

      // Update conversation in local state
      final archivedConversation = conversation.copyWith(isArchived: true);
      _addOrUpdateConversation(archivedConversation);

      _log.info('Successfully archived conversation $conversationId');
    } catch (e, st) {
      _log.severe('Error archiving conversation', e, st);
      throw Exception('Error archiving conversation: $e');
    }
  }

  @override
  Future<void> unarchiveConversation(String conversationId) async {
    _log.fine('Unarchiving conversation $conversationId');
    try {
      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      // Update archived status
      await _updateArchivedStatus(conversationId, false);

      // Update conversation in local state
      final unarchivedConversation = conversation.copyWith(isArchived: false);
      _addOrUpdateConversation(unarchivedConversation);

      _log.info('Successfully unarchived conversation $conversationId');
    } catch (e, st) {
      _log.severe('Error unarchiving conversation', e, st);
      throw Exception('Error unarchiving conversation: $e');
    }
  }

  @override
  Future<void> leaveConversation(String conversationId) async {
    _log.fine('Leaving conversation $conversationId');
    try {
      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      // Mark as left by sharing status key with all participants
      final statusKey = '$kStatusPrefix.$conversationId';
      final leftMessage = {
        'status': 'left',
        'timestamp': DateTime.now().toIso8601String(),
        'atsign': atClient.getCurrentAtSign(),
      };

      for (String participant in conversation.participants) {
        AtKey statusAtKey = AtKey()
          ..key = statusKey
          ..namespace = namespace
          ..sharedWith = participant
          ..sharedBy = atClient.getCurrentAtSign();

        await atClient.put(statusAtKey, jsonEncode(leftMessage));

        await atClient.notificationService.notify(
          NotificationParams.forUpdate(statusAtKey, value: jsonEncode(leftMessage)),
        );
      }

      // Update local state
      final updatedConversation = conversation.copyWith(hasLeft: true);
      _addOrUpdateConversation(updatedConversation);

      _log.info('Successfully left conversation $conversationId');
    } catch (e, st) {
      _log.severe('Error leaving conversation', e, st);
      throw Exception('Error leaving conversation: $e');
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    _log.fine('Deleting conversation $conversationId');
    try {
      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      // Mark as left first
      await leaveConversation(conversationId);

      // Delete conversation and messages that exist only on owner's atserver
      final currentAtSign = atClient.getCurrentAtSign();
      if (conversation.createdBy == currentAtSign) {
        final convRegex = RegExp('$kConvPrefix\\.$conversationId\\..*');

        // Get all conversations keys (will only return keys for conversations started by the current atsign)
        List<AtKey> conversationKeys = await atClient.getAtKeys(regex: convRegex.pattern, sharedBy: currentAtSign);

        for (AtKey convKey in conversationKeys) {
          final success = await atClient.delete(convKey);
          if (success) {
            _log.fine('Successfully deleted conversation key: $convKey');
          } else {
            _log.warning('Failed to delete conversation key: $convKey');
          }
        }

        // Delete all messages created by this user
        final regex = RegExp('$kConvPrefix\\.$conversationId\\.$kMsgPrefix');
        List<AtKey> messageKeys = await atClient.getAtKeys(regex: regex.pattern, sharedBy: currentAtSign);

        for (AtKey msgKey in messageKeys) {
          if (msgKey.sharedBy == currentAtSign) {
            final success = await atClient.delete(msgKey);
            if (success) {
              _log.fine('Successfully deleted message key: $msgKey');
            } else {
              _log.warning('Failed to delete message key: $msgKey');
            }
          }
        }

        // Remove archived status if present
        await _updateArchivedStatus(conversationId, false);
      }

      _log.info('Successfully deleted conversation $conversationId');
    } catch (e, st) {
      _log.severe('Error deleting conversation', e, st);
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
      _log.fine('Sending message to conversation: $conversationId');

      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      _addMessageToConversation(conversationId, message);

      // Create message key with timestamp for uniqueness
      String messageKey = '$kConvPrefix.$conversationId.$kMsgPrefix.${message.timestamp.millisecondsSinceEpoch}';

      // Send message to each participant (except ourselves)
      for (String participant in conversation.participants) {
        if (participant != atClient.getCurrentAtSign()) {
          // Check if participant has left the conversation
          if (await _hasParticipantLeft(conversationId, participant)) {
            _log.info('Skipping message to $participant - they have left the conversation');
            continue;
          }

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
            _log.info('Message sent to $participant');
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
      _log.severe('Error sending message', e, st);
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
      _log.fine('Deleting message: $messageId from conversation: $conversationId');

      final conversation = _getConversation(conversationId);
      if (conversation == null) {
        throw Exception('Conversation not found');
      }

      // Find the message
      final message = conversation.messages.firstWhereOrNull(
        (m) => m.id == messageId,
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

      // Remove from local state
      late final List<AppMessage> updatedMessages;
      updatedMessages = List<AppMessage>.from(conversation.messages);
      final messageIndex = updatedMessages.indexOf(message);
      if (quietly) {
        final _ = updatedMessages.removeAt(messageIndex);
      } else {
        final updatedMessage = message.copyWith(content: const DeletedContent());
        updatedMessages[messageIndex] = updatedMessage;
      }
      final updatedConversation = conversation.copyWith(messages: updatedMessages);
      _addOrUpdateConversation(updatedConversation);

      // Create message key
      String messageKey = '$kConvPrefix.$conversationId.$kMsgPrefix.$timestamp';

      // Delete message for each participant
      for (String participant in conversation.participants) {
        if (participant != atClient.getCurrentAtSign()) {
          AtKey msgKey = AtKey()
            ..key = messageKey
            ..namespace = namespace
            ..sharedWith = participant
            ..sharedBy = atClient.getCurrentAtSign();

          if (quietly) {
            _log.fine('Deleting message key: $msgKey quietly');
            final success = await atClient.delete(msgKey);
            if (success) {
              _log.fine('Successfully deleted message key: $msgKey');
              await atClient.notificationService.notify(
                NotificationParams.forDelete(msgKey),
                // This means we wait for the notifications to reach "our" secondary but not "their" secondary
                waitForFinalDeliveryStatus: false,
              );
            } else {
              _log.warning('Failed to delete message key: $msgKey');
            }
          } else {
            _log.fine('Updating message key $msgKey with deletion status');
            final updatedAppMessage = message.copyWith(content: const DeletedContent());
            final updatedMessage = _convertFromAppMessage(updatedAppMessage, conversationId, participant);
            final updatedMessageJson = jsonEncode(updatedMessage.toMap());
            final success = await atClient.put(msgKey, updatedMessageJson);
            if (success) {
              _log.fine('Successfully updated message key: $msgKey');
              await atClient.notificationService.notify(
                NotificationParams.forUpdate(msgKey, value: updatedMessageJson),
                waitForFinalDeliveryStatus: false,
              );
            } else {
              _log.warning('Failed to update message key: $msgKey');
            }
          }
        }
      }
    } catch (e, st) {
      // TODO: On failure, add message back to local state.
      _log.severe('Error deleting message', e, st);
      throw Exception('Error deleting message: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _log.fine('Disposing app conversation repository');
    await _conversationNotificationSubscription?.cancel();
    await _messageNotificationSubscription?.cancel();
    _periodicRefresh?.cancel();
    await _conversations.close();
  }
}
