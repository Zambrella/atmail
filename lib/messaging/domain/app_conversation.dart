import 'package:atmail/messaging/domain/app_message.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'app_conversation.mapper.dart';

@MappableClass()
class AppConversation with AppConversationMappable implements Comparable<AppConversation> {
  const AppConversation({
    required this.id,
    required this.subject,
    required this.participants,
    required this.createdAt,
    required this.createdBy,
    required this.messages,
    this.previousConversationId,
    this.isArchived = false,
    this.hasLeft = false,
    this.metadata = const {},
  });

  /// Unique identifier for the conversation.
  final String id;

  /// The subject of the conversation.
  /// Similar to the subject of an email.
  final String subject;

  /// The atsign participants of the conversation.
  /// The atsigns should be formatted as '@username'.
  final List<String> participants;

  /// The date and time when the conversation was created.
  final DateTime createdAt;

  /// The atsign of the user who created the conversation.
  final String createdBy;

  /// The messages in the conversation.
  final List<AppMessage> messages;

  /// The id of a previous conversation.
  /// Null if this is the first conversation.
  final String? previousConversationId;

  /// Whether the conversation is archived.
  final bool isArchived;

  /// Whether the user has left the conversation.
  final bool hasLeft;

  /// Additional metadata associated with the conversation.
  /// TODO: Update with examples.
  final Map<String, dynamic> metadata;

  String? get latestMessageSender => messages.lastOrNull?.sender;

  MessageContent? get latestMessage => messages.lastOrNull?.content;

  DateTime? get latestMessageDate => messages.lastOrNull?.timestamp;

  @override
  int compareTo(AppConversation other) {
    DateTime aTime = latestMessageDate ?? createdAt;
    DateTime bTime = other.latestMessageDate ?? other.createdAt;
    return bTime.compareTo(aTime);
  }
}
