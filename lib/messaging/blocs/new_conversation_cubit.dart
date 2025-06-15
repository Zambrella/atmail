import 'package:at_utils/at_utils.dart';
import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class NewConversationState {
  const NewConversationState();
}

class NewConversationInitial extends NewConversationState {}

class NewConversationLoading extends NewConversationState {}

class NewConversationSuccess extends NewConversationState {
  const NewConversationSuccess(this.newConversation);

  final AppConversation newConversation;
}

class NewConversationError extends NewConversationState {
  const NewConversationError(this.errorMessage);

  final String errorMessage;
}

class NewConversationCubit extends Cubit<NewConversationState> {
  NewConversationCubit(this._conversationRepository) : super(NewConversationInitial());

  final AppConversationRepository _conversationRepository;

  void createConversation(List<String> recipients, String subject, String message) async {
    emit(NewConversationLoading());
    try {
      if (recipients.isEmpty) {
        throw Exception('Recipients cannot be empty');
      }
      late final AppConversation conversation;
      if (recipients.length == 1) {
        conversation = await _conversationRepository.startConversation(
          withAtSign: AtUtils.fixAtSign(recipients.first),
          subject: subject,
          initialMessage: message,
        );
      } else {
        conversation = await _conversationRepository.startGroupConversation(
          withAtSigns: recipients.map(AtUtils.fixAtSign).toList(),
          subject: subject,
          initialMessage: message,
        );
      }
      emit(NewConversationSuccess(conversation));
    } catch (error) {
      emit(NewConversationError(error.toString()));
    }
  }
}
