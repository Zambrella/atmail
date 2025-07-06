import 'package:atmail/messaging/domain/message_status.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'app_message.mapper.dart';

@MappableClass()
class AppMessage with AppMessageMappable implements Comparable<AppMessage> {
  AppMessage({
    required this.timestamp,
    required this.content,
    required this.status,
    required this.sender,
    this.metadata = const {},
  });

  /// The timestamp of the message.
  /// Acts as the unique identifier for the message as well.
  final DateTime timestamp;

  // /// The contents of the message.
  final MessageContent content;

  /// The sending status of the message.
  final MessageStatus status;

  /// The sender of the message.
  final String sender;

  /// Additional metadata for the message.
  final Map<String, dynamic> metadata;

  @override
  int compareTo(AppMessage other) {
    return other.timestamp.compareTo(timestamp);
  }

  String get id => timestamp.millisecondsSinceEpoch.toString();

  /// Formats the date of the latest message.
  /// Formats it as a relative date if it's within the last week,
  /// otherwise formats it as a full date.
  String dateFormatted() {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays <= 7) {
      return timeago.format(timestamp);
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}
