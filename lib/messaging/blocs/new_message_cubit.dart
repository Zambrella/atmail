// TODO: This cubit will add a new message to the conversation straight away before sending it to the server.
// This might require creating the new message object before sending it to the repository.
import 'dart:async';

import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
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
    unawaited(_conversationRepository.sendMessage(conversationId: conversationId, textMessage: message));
  }
}
