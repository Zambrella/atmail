import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ConversationArchiveState {
  const ConversationArchiveState();
}

class ConversationArchiveStateInitial extends ConversationArchiveState {
  const ConversationArchiveStateInitial();
}

class ConversationArchiveStateSaving extends ConversationArchiveState {
  const ConversationArchiveStateSaving();
}

class ConversationArchiveStateSuccess extends ConversationArchiveState {
  const ConversationArchiveStateSuccess();
}

class ConversationArchiveStateError extends ConversationArchiveState {
  const ConversationArchiveStateError(this.error);

  final String error;
}

// TODO: Chnge this to `ArchiveConvesationCubit`
class ArchiveConversationCubit extends Cubit<ConversationArchiveState> {
  ArchiveConversationCubit(this._conversationRepository, {required this.conversationId})
    : super(const ConversationArchiveStateInitial());

  final AppConversationRepository _conversationRepository;
  final String conversationId;

  void archiveConversation() async {
    emit(const ConversationArchiveStateSaving());
    try {
      await _conversationRepository.archiveConversation(conversationId);
      emit(const ConversationArchiveStateSuccess());
    } catch (e) {
      emit(ConversationArchiveStateError(e.toString()));
    }
  }

  void unarchiveConversation() async {
    emit(const ConversationArchiveStateSaving());
    try {
      await _conversationRepository.unarchiveConversation(conversationId);
      emit(const ConversationArchiveStateSuccess());
    } catch (e) {
      emit(ConversationArchiveStateError(e.toString()));
    }
  }
}
