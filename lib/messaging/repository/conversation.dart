import 'package:dart_mappable/dart_mappable.dart';

part 'conversation.mapper.dart';

@MappableClass()
class Conversation with ConversationMappable implements Comparable<Conversation> {
  const Conversation({
    required this.id,
    required this.subject,
    required this.participants,
    required this.createdAt,
    required this.createdBy,
    this.previousConversationId,
    this.metadata = const {},
  });

  /// The unique id of the conversation.
  final String id;

  /// The subject of the conversation.
  /// Similar to the subject of an email.
  final String subject;

  /// The atsign participants of the conversation.
  final List<String> participants;

  /// The date and time when the conversation was created.
  final DateTime createdAt;

  /// The atsign of the user who created the conversation.
  final String createdBy;

  /// The id of a previous conversation.
  /// Null if this is the first conversation.
  final String? previousConversationId;

  /// Additional metadata associated with the conversation.
  /// TODO: Update with examples.
  final Map<String, dynamic> metadata;

  @override
  int compareTo(Conversation other) {
    return createdAt.compareTo(other.createdAt);
  }
}
