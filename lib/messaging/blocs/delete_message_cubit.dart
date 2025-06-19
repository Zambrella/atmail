import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/domain/app_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class DeleteMessageState {
  const DeleteMessageState();
}

class DeleteMessageStateInitial extends DeleteMessageState {
  const DeleteMessageStateInitial();
}

class DeleteMessageStateSuccess extends DeleteMessageState {
  const DeleteMessageStateSuccess();
}

class DeleteMessageStateInProgress extends DeleteMessageState {
  const DeleteMessageStateInProgress();
}

class DeleteMessageStateFailure extends DeleteMessageState {
  const DeleteMessageStateFailure(this.errorMessage);

  final String errorMessage;
}

class DeleteMessageCubit extends Cubit<DeleteMessageState> {
  DeleteMessageCubit(this._conversationRepository, {required this.conversationId})
    : super(const DeleteMessageStateInitial());

  final AppConversationRepository _conversationRepository;
  final String conversationId;

  void deleteMessage(AppMessage message, bool quietly) async {
    try {
      emit(const DeleteMessageStateInProgress());
      await _conversationRepository.deleteMessage(
        conversationId: conversationId,
        messageId: message.id,
        quietly: quietly,
      );
      emit(const DeleteMessageStateSuccess());
    } catch (e) {
      emit(DeleteMessageStateFailure(e.toString()));
    }
  }
}
