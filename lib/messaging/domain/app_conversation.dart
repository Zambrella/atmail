import 'package:atmail/messaging/domain/app_message.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'app_conversation.mapper.dart';

@MappableClass()
class AppConversation with AppConversationMappable implements Comparable<AppConversation> {
  const AppConversation({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.createdBy,
    required this.messages,
    this.metadata = const {},
  });

  /// Unique identifier for the conversation.
  final String id;

  /// The atsign participants of the conversation.
  final List<String> participants;

  /// The date and time when the conversation was created.
  final DateTime createdAt;

  /// The atsign of the user who created the conversation.
  final String createdBy;

  /// The messages in the conversation.
  final List<AppMessage> messages;

  /// Additional metadata associated with the conversation.
  /// TODO: Update with examples.
  final Map<String, dynamic> metadata;

  String? get latestMessageSender => messages.lastOrNull?.sender;

  String? get latestMessage => messages.lastOrNull?.text;

  DateTime? get latestMessageDate => messages.lastOrNull?.timestamp;

  @override
  int compareTo(AppConversation other) {
    DateTime aTime = latestMessageDate ?? createdAt;
    DateTime bTime = other.latestMessageDate ?? other.createdAt;
    return bTime.compareTo(aTime);
  }
}
