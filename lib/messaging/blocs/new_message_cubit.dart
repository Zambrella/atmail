import 'dart:async';

import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewMessageState {
  const NewMessageState();
}

// This will just validate the message and send it off.
// It's up to the conversation to handle the message state changes.
class NewMessageCubit extends Cubit<NewMessageState> {
  NewMessageCubit(
    this._conversationRepository, {
    required this.conversationId,
  }) : super(NewMessageState());

  final AppConversationRepository _conversationRepository;
  final String conversationId;

  void addMessage(String message) {
    final content = TextContent(message);
    unawaited(_conversationRepository.sendMessage(conversationId: conversationId, content: content));
  }
}
