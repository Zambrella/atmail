import 'package:atmail/messaging/domain/message.dart';
import 'package:atmail/messaging/domain/message_type.dart';

abstract interface class MessageRepository {
  Future<Message> sendMessage({
    required String conversationId,
    required String message,
    required MessageType type,
    Map<String, dynamic>? metadata,
  });

  Stream<List<Message>> fetchMessages({
    required String conversationId,
  });

  Future<bool> deleteMessage({
    required String conversationId,
    required String messageId,
  });

  Future<void> dispose();
}
