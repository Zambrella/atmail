import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class LeaveConversationState {
  const LeaveConversationState();
}

class LeaveConversationInitial extends LeaveConversationState {
  const LeaveConversationInitial();
}

class LeaveConversationLoading extends LeaveConversationState {
  const LeaveConversationLoading();
}

class LeaveConversationSuccess extends LeaveConversationState {
  const LeaveConversationSuccess();
}

class LeaveConversationFailure extends LeaveConversationState {
  const LeaveConversationFailure(this.error);

  final String error;
}

class LeaveConversationCubit extends Cubit<LeaveConversationState> {
  LeaveConversationCubit(this._conversationRepository, {required this.conversationId})
    : super(const LeaveConversationInitial());

  final AppConversationRepository _conversationRepository;
  final String conversationId;

  void leaveConversation() async {
    emit(const LeaveConversationLoading());
    try {
      await _conversationRepository.leaveConversation(conversationId);
      emit(const LeaveConversationSuccess());
    } catch (error) {
      emit(LeaveConversationFailure(error.toString()));
    }
  }
}
