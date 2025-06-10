import 'package:dart_mappable/dart_mappable.dart';

part 'conversation.mapper.dart';

@MappableClass()
class Conversation with ConversationMappable implements Comparable<Conversation> {
  const Conversation({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.createdBy,
    this.metadata = const {},
  });

  /// The unique id of the conversation.
  final String id;

  /// The atsign participants of the conversation.
  final List<String> participants;

  /// The date and time when the conversation was created.
  final DateTime createdAt;

  /// The atsign of the user who created the conversation.
  final String createdBy;

  /// Additional metadata associated with the conversation.
  /// TODO: Update with examples.
  final Map<String, dynamic> metadata;

  @override
  int compareTo(Conversation other) {
    return createdAt.compareTo(other.createdAt);
  }
}
