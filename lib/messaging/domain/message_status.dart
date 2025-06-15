import 'package:dart_mappable/dart_mappable.dart';

part 'message_status.mapper.dart';

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
