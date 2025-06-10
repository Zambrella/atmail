import 'dart:async';
import 'dart:convert';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/messaging/domain/conversation.dart';
import 'package:atmail/messaging/domain/conversation_repository.abs.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

final logger = Logger('ConversationRepositoryImpl');

class ConversationRepositoryImpl implements ConversationRepository {
  ConversationRepositoryImpl({
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

  final BehaviorSubject<List<Conversation>> _conversations = BehaviorSubject<List<Conversation>>.seeded([]);

  // Track which conversations we've already discovered
  final Set<String> _discoveredConversationIds = {};

  StreamSubscription? _notificationSubscription;
  Timer? _periodicRefresh;

  void _initialize() {
    logger.fine('Initializing conversation repository');

    // Listen for real-time notifications
    _startNotificationListener();

    // Initial load of conversations
    _loadAllConversations();

    // Periodic refresh to catch any missed conversations (every 30 seconds)
    _periodicRefresh = Timer.periodic(Duration(seconds: 30), (_) {
      _refreshConversations();
    });
  }

  void _startNotificationListener() {
    logger.fine('Setting up conversation listener');
    _notificationSubscription = atClient.notificationService
        .subscribe(regex: '$kConvPrefix\\..*\\.$namespace', shouldDecrypt: true)
        .listen((notification) async {
          logger.fine('Received conversation notification: $notification');
          await _handleNotification(notification);
        });
  }

  Future<void> _handleNotification(AtNotification notification) async {
    try {
      // Check if this is a conversation-related notification
      if (notification.key.contains(kConvPrefix)) {
        // Extract conversation ID from the key
        String? conversationId = _extractConversationId(notification.key);
        if (conversationId != null) {
          // Load or update this specific conversation
          logger.info('Received conversation notification for conversation ID: $conversationId');
          await _loadConversation(conversationId, notification.from);
        } else {
          logger.warning('Received conversation notification with invalid key: $notification');
        }
      } else {
        logger.warning('Received unknown notification that should have been filtered by regex: $notification');
      }
    } catch (e, st) {
      logger.severe('Error handling notification', e, st);
    }
  }

  String? _extractConversationId(String key) {
    // Extract conversation ID from keys like:
    // @bob:conv.123abc.atmail@alice
    try {
      final parts = key.split('.');
      if (parts.length >= 2) {
        if (parts[0].contains(kConvPrefix)) {
          return parts[1];
        }
      }
    } catch (e, st) {
      logger.severe('Error extracting conversation ID', e, st);
    }
    return null;
  }

  Future<void> _loadAllConversations() async {
    logger.fine('Loading all conversations');
    try {
      // Pattern 1: Load conversations we've created (as sender)
      await _loadSentConversations();

      // Pattern 2: Load conversations others have started with us
      await _loadReceivedConversations();

      // Pattern 3: Check conversation index if implemented
      await _loadFromConversationIndex();
    } catch (e, st) {
      logger.severe('Error loading all conversations', e, st);
    }
  }

  Future<void> _loadSentConversations() async {
    logger.fine('Loading sent conversations');
    // Get all conversation keys we've created
    List<AtKey> convKeys = await atClient.getAtKeys(
      regex: '^@[^:]+:$kConvPrefix\\..*\\.$namespace@${atClient.getCurrentAtSign()}\$',
    );

    logger.info('Sent conversation keys: $convKeys');

    for (AtKey key in convKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Map<String, dynamic> convData = jsonDecode(value.value);
          String conversationId = convData['conversationId'] ?? '';

          if (!_discoveredConversationIds.contains(conversationId)) {
            _discoveredConversationIds.add(conversationId);

            Conversation conversation = ConversationMapper.fromMap(convData);

            _addOrUpdateConversation(conversation);
          }
        }
      } catch (e, st) {
        logger.severe('Error loading sent conversation', e, st);
      }
    }
  }

  Future<void> _loadReceivedConversations() async {
    logger.fine('Loading received conversations');
    // Get conversation keys (conversations others shared with us)
    List<AtKey> receivedKeys = await atClient.getAtKeys(
      regex: '$kConvPrefix\\..*\\.$namespace',
    );

    logger.info('Received conversation keys: $receivedKeys');

    for (AtKey key in receivedKeys) {
      try {
        AtValue value = await atClient.get(key);
        if (value.value != null) {
          Map<String, dynamic> convData = jsonDecode(value.value);
          String conversationId = convData['conversationId'] ?? '';

          if (!_discoveredConversationIds.contains(conversationId)) {
            _discoveredConversationIds.add(conversationId);

            Conversation conversation = ConversationMapper.fromMap(convData);

            _addOrUpdateConversation(conversation);
          }
        }
      } catch (e, st) {
        logger.severe('Error loading received conversation', e, st);
      }
    }
  }

  Future<void> _loadFromConversationIndex() async {
    logger.fine('Loading conversation index');
    // Try to load conversation index from known contacts
    // This is similar to atmospherePro's message index pattern
    try {
      // Get list of contacts or scan for conversation indices
      List<AtKey> indexKeys = await atClient.getAtKeys(
        regex:
            '^(@${atClient.getCurrentAtSign()}:|cached:@${atClient.getCurrentAtSign()}:)$kConvIndexPrefix\\.$namespace@.*',
      );

      for (AtKey indexKey in indexKeys) {
        try {
          AtValue indexValue = await atClient.get(indexKey);
          if (indexValue.value != null) {
            List<String> conversationIds = List<String>.from(jsonDecode(indexValue.value));

            for (String convId in conversationIds) {
              if (!_discoveredConversationIds.contains(convId)) {
                await _loadConversation(convId, indexKey.sharedBy!);
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

  Future<void> _loadConversation(String conversationId, String fromAtSign) async {
    logger.fine('Loading conversation $conversationId from $fromAtSign');
    try {
      // Try to fetch the conversation details
      AtKey convKey = AtKey()
        ..key = '$kConvPrefix.$conversationId'
        ..namespace = namespace
        ..sharedBy = fromAtSign
        ..sharedWith = atClient.getCurrentAtSign();

      AtValue value = await atClient.get(convKey);
      if (value.value != null) {
        Map<String, dynamic> convData = jsonDecode(value.value);

        if (!_discoveredConversationIds.contains(conversationId)) {
          _discoveredConversationIds.add(conversationId);

          Conversation conversation = ConversationMapper.fromMap(convData);
          logger.fine('Loaded conversation $conversation');

          _addOrUpdateConversation(conversation);
        }
      }
    } catch (e, stackTrace) {
      logger.severe('Error loading conversation $conversationId: $e', e, stackTrace);
    }
  }

  // Future<int> _calculateUnreadCount(String conversationId) async {
  //   // TODO: Implement unread count calculation based on last read timestamp
  //   return 0;
  // }

  void _addOrUpdateConversation(Conversation conversation) {
    final currentList = List<Conversation>.from(_conversations.value);
    final index = currentList.indexWhere((c) => c.id == conversation.id);

    if (index >= 0) {
      logger.fine('Updating conversation $conversation');
      currentList[index] = conversation;
    } else {
      logger.fine('Adding conversation $conversation');
      currentList.add(conversation);
    }

    // Sort by most recent first
    currentList.sort();

    _conversations.add(currentList);
  }

  Future<void> _refreshConversations() async {
    // Only refresh to catch new conversations, not reload everything
    await _loadReceivedConversations();
  }

  @override
  Future<Conversation> startConversation({
    required String withAtSign,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.fine('Starting conversation with $withAtSign');

      // Generate unique conversation ID
      String conversationId = Uuid().v4();
      DateTime now = DateTime.now();

      // Create conversation object
      Conversation conversation = Conversation(
        id: conversationId,
        participants: [atClient.getCurrentAtSign()!, withAtSign],
        createdAt: now,
        createdBy: atClient.getCurrentAtSign()!,
        metadata: metadata ?? {},
      );

      logger.fine('Conversation object created: $conversation');

      // Prepare conversation data
      Map<String, dynamic> convData = conversation.toMap();

      // Create shared key for the conversation
      AtKey convKey =
          (AtKey.shared(
                  '$kConvPrefix.$conversationId',
                  namespace: namespace,
                )
                ..sharedWith(withAtSign)
                ..cache(-1, true))
              .build();

      // Store conversation data
      bool stored = await atClient.put(convKey, jsonEncode(convData));

      if (stored) {
        logger.info('Conversation successfully put');
        // Send notification to the other participant
        await atClient.notificationService.notify(
          NotificationParams.forUpdate(convKey, value: jsonEncode(convData)),
        );
        logger.info('Notification sent');

        // Update local conversation index
        await _updateConversationIndex(conversationId);

        // Add to local list
        _discoveredConversationIds.add(conversationId);
        _addOrUpdateConversation(conversation);

        return conversation;
      } else {
        logger.severe('Failed to put conversation to secondary');
        throw Exception('Failed to create conversation');
      }
    } catch (e, st) {
      logger.severe('Error starting conversation', e, st);
      throw Exception('Error starting conversation: $e');
    }
  }

  @override
  Future<Conversation> startGroupConversation({
    required List<String> withAtSigns,
    String? groupName,
    Map<String, dynamic>? metadata,
  }) async {
    logger.fine('Starting conversation with $withAtSigns');
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

      Conversation conversation = Conversation(
        id: conversationId,
        participants: allParticipants,
        createdAt: now,
        createdBy: atClient.getCurrentAtSign()!,
        metadata: convMetadata,
      );

      logger.fine('Conversation object created: $conversation');

      Map<String, dynamic> convData = conversation.toMap();

      // Share conversation with each participant
      for (String participant in withAtSigns) {
        AtKey convKey = (AtKey.shared(
          '$kConvPrefix.$conversationId',
          namespace: namespace,
        )..sharedWith(participant)).build();

        await atClient.put(convKey, jsonEncode(convData));

        // Notify each participant
        await atClient.notificationService.notify(
          NotificationParams.forUpdate(convKey, value: jsonEncode(convData)),
        );

        logger.fine('Conversation shared with $participant');
      }

      // Update local index
      await _updateConversationIndex(conversationId);

      _discoveredConversationIds.add(conversationId);
      _addOrUpdateConversation(conversation);

      return conversation;
    } catch (e, st) {
      logger.severe('Error starting group conversation', e, st);
      throw Exception('Error starting group conversation: $e');
    }
  }

  Future<void> _updateConversationIndex(String conversationId) async {
    logger.fine('Updating conversation $conversationId index');
    try {
      // Maintain an index of all conversation IDs for easier discovery
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
      logger.severe('Error updated conversation index', e, st);
      print('Error updating conversation index: $e');
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    logger.fine('Deleting conversation $conversationId');
    try {
      // Find the conversation
      final conversations = _conversations.value;
      final conversation = conversations.firstWhere(
        (c) => c.id == conversationId,
        orElse: () => throw Exception('Conversation not found'),
      );

      // Delete shared keys for each participant
      for (String participant in conversation.participants) {
        if (participant != atClient.getCurrentAtSign()) {
          AtKey convKey = AtKey()
            ..key = '$kConvPrefix.$conversationId'
            ..namespace = namespace
            ..sharedWith = participant
            ..sharedBy = atClient.getCurrentAtSign();

          await atClient.delete(convKey);
        }
      }

      // Remove from conversation index
      await _removeFromConversationIndex(conversationId);

      // Remove from local list
      _discoveredConversationIds.remove(conversationId);
      final updatedList = conversations.where((c) => c.id != conversationId).toList();
      _conversations.add(updatedList);
    } catch (e, st) {
      logger.severe('Error deleting conversation', e, st);
      throw Exception('Error deleting conversation: $e');
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
      logger.severe('Error removing from conversation index', e, st);
    }
  }

  @override
  Stream<List<Conversation>> getConversations() {
    return _conversations.stream;
  }

  @override
  Future<void> dispose() async {
    _notificationSubscription?.cancel();
    _periodicRefresh?.cancel();
    _conversations.close();
  }
}
