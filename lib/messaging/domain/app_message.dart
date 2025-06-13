import 'package:atmail/messaging/domain/message_type.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'app_message.mapper.dart';

/// Base class for all message statuses.
@MappableClass()
sealed class MessageStatus with MessageStatusMappable {
  const MessageStatus();
}

/// The message hasn't been sent to the secondary yet.
@MappableClass()
class MessageStatusPending extends MessageStatus with MessageStatusPendingMappable {
  const MessageStatusPending();
}

/// The message has been sent to the secondary.
@MappableClass()
class MessageStatusSent extends MessageStatus with MessageStatusSentMappable {
  const MessageStatusSent();
}

/// The message has been delivered to the recipient.
@MappableClass()
class MessageStatusDelivered extends MessageStatus with MessageStatusDeliveredMappable {
  const MessageStatusDelivered();
}

/// The message has encountered an error and should be retried.
@MappableClass()
class MessageStatusError extends MessageStatus with MessageStatusErrorMappable {
  const MessageStatusError(this.message, this.exception);

  final String message;
  final Exception exception;
}

@MappableClass()
class AppMessage with AppMessageMappable implements Comparable<AppMessage> {
  AppMessage({
    required this.timestamp,
    required this.text,
    required this.type,
    required this.status,
    required this.sender,
    this.metadata = const {},
  });

  /// The timestamp of the message.
  /// Acts as the unique identifier for the message as well.
  final DateTime timestamp;

  /// The contents of the message.
  final String text;

  /// The type of the message.
  final MessageType type;

  /// The sending status of the message.
  final MessageStatus status;

  /// The sender of the message.
  final String sender;

  /// Additional metadata for the message.
  final Map<String, dynamic> metadata;

  @override
  int compareTo(AppMessage other) {
    return timestamp.compareTo(other.timestamp);
  }
}
