import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/domain/app_message.dart';

abstract interface class AppConversationRepository {
  /// Start a one-to-one conversation with another atsign.
  Future<AppConversation> startConversation({
    required String withAtSign,
    required AppMessage initialMessage,
    Map<String, dynamic>? metadata,
  });

  /// Start a group conversation with a list of atsigns.
  Future<AppConversation> startGroupConversation({
    required List<String> withAtSigns,
    required AppMessage initialMessage,
    String? groupName,
    Map<String, dynamic>? metadata,
  });

  /// Get a list of all conversations the user is part of.
  /// Updates the list of conversations when new conversations are created or deleted.
  /// When a new message is sent or received, the list of conversations is updated.
  Stream<List<AppConversation>> getConversations();

  /// Delete a conversation.
  /// Only possible if the caller is the creator of the conversation.
  Future<void> deleteConversation(String conversationId);

  /// Send a message to a conversation.
  /// When the message is sent, the list of conversations is updated.
  Future<AppMessage> sendMessage({
    required String conversationId,
    required AppMessage message,
  });

  /// Delete a message from a conversation.
  /// Only possible if the caller is the creator of the message.
  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  });

  /// Dispose of the repository to free up resources.
  Future<void> dispose();
}
