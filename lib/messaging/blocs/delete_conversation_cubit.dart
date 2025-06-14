import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class DeleteConversationState {
  const DeleteConversationState();
}

class DeleteConversationInitial extends DeleteConversationState {
  const DeleteConversationInitial();
}

class DeleteConversationLoading extends DeleteConversationState {
  const DeleteConversationLoading();
}

class DeleteConversationSuccess extends DeleteConversationState {
  const DeleteConversationSuccess();
}

class DeleteConversationFailure extends DeleteConversationState {
  const DeleteConversationFailure(this.message);

  final String message;
}

class DeleteConversationCubit extends Cubit<DeleteConversationState> {
  DeleteConversationCubit(
    this._conversationRepository,
  ) : super(const DeleteConversationInitial());

  final AppConversationRepository _conversationRepository;

  Future<void> deleteConversation(String conversationId) async {
    emit(const DeleteConversationLoading());
    try {
      await _conversationRepository.deleteConversation(conversationId);
      emit(const DeleteConversationSuccess());
    } catch (e) {
      emit(DeleteConversationFailure(e.toString()));
    }
  }
}
