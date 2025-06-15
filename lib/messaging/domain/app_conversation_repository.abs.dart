import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/domain/app_message.dart';
import 'package:atmail/messaging/domain/message_content.dart';

abstract interface class AppConversationRepository {
  /// Start a one-to-one conversation with another atsign.
  /// This creates a new conversation with the given atsign and sends the initial message.
  Future<AppConversation> startConversation({
    required String withAtSign,
    required String initialMessage,
    required String subject,
    Map<String, dynamic>? metadata,
  });

  /// Start a group conversation with a list of atsigns.
  /// This creates a new conversation with the given atsigns and sends the initial message.
  Future<AppConversation> startGroupConversation({
    required List<String> withAtSigns,
    required String initialMessage,
    required String subject,
    String? groupName,
    Map<String, dynamic>? metadata,
  });

  /// Get a list of all conversations the user is part of.
  /// Updates the list of conversations when new conversations are created or deleted.
  /// When a new message is sent or received, the list of conversations is updated.
  Stream<List<AppConversation>> getConversations();

  // TODO:
  Future<List<AppConversation>> getArchivedConversations();

  /// Leave a conversation and receive no further updates.
  /// This sends a notification to other participants that the user is not interested in receiving updates or shared
  /// keys.
  Future<void> leaveConversation(String conversationId);

  /// Marks the conversation as archived and won't be returned in the list of conversations by default.
  Future<void> archiveConversation(String conversationId);

  /// Delete all reference to the conversation and messages that are stored on the atserver.
  /// Will also mark the conversation as left.
  Future<void> deleteConversation(String conversationId);

  /// Send a message to a conversation.
  /// When the message is sent, the list of conversations is updated.
  Future<AppMessage> sendMessage({
    required String conversationId,
    required MessageContent content,
  });

  /// Delete a message from a conversation.
  /// Only possible if the caller is the creator of the message.
  /// If `quietly` is true, the message is deleted without leaving a sentinel deletion message.
  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
    bool quietly = false,
  });

  /// Dispose of the repository to free up resources.
  Future<void> dispose();
}
