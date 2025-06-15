import 'package:atmail/messaging/domain/message_content.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'message.mapper.dart';

@MappableClass()
class Message with MessageMappable implements Comparable<Message> {
  const Message({
    required this.timestamp,
    required this.conversationId,
    required this.content,
    required this.from,
    required this.to,
    this.metadata = const {},
  });

  /// The timestamp of the message.
  /// Acts as the unique identifier for the message as well.
  final DateTime timestamp;

  /// Unique identifier for the conversation this message belongs to.
  final String conversationId;

  /// The content of the message.
  final MessageContent content;

  /// The sender of the message.
  final String from;

  /// The recipient of the message.
  final String to;

  /// Additional metadata for the message.
  final Map<String, dynamic> metadata;

  @override
  int compareTo(Message other) {
    return timestamp.compareTo(other.timestamp);
  }
}
