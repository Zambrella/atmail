import 'package:atmail/messaging/domain/conversation.dart';

abstract interface class ConversationRepository {
  /// Start a one-to-one conversation with another atsign.
  /// No message is sent, just a conversation.
  Future<Conversation> startConversation({
    required String withAtSign,
    Map<String, dynamic>? metadata,
  });

  /// Start a group conversation with a list of atsigns.
  /// No message is sent, just a conversation.
  Future<Conversation> startGroupConversation({
    required List<String> withAtSigns,
    String? groupName,
    Map<String, dynamic>? metadata,
  });

  /// Get a list of all conversations the user is part of.
  /// Updates the list of conversations when new conversations are created or deleted.
  Stream<List<Conversation>> getConversations();

  /// Delete a conversation.
  /// Only possible if the caller is the creator of the conversation.
  Future<void> deleteConversation(String conversationId);

  /// Dispose of the repository to free up resources.
  Future<void> dispose();
}
