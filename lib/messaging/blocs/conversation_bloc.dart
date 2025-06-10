import 'package:atmail/messaging/domain/conversation.dart';
import 'package:atmail/messaging/domain/conversation_repository.abs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConversationStatus { loading, success, failure }

class ConversationState extends Equatable {
  const ConversationState({
    required this.status,
    required this.conversations,
    this.exception,
  });

  final ConversationStatus status;
  final List<Conversation> conversations;
  final Exception? exception;

  @override
  List<Object?> get props => [status, conversations, exception];

  ConversationState copyWith({
    ConversationStatus? status,
    List<Conversation>? conversations,
    Exception? exception,
  }) {
    return ConversationState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      exception: exception ?? this.exception,
    );
  }
}

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit(this._conversationRepository)
    : super(ConversationState(status: ConversationStatus.loading, conversations: [])) {
    // TODO: This also needs to pull in the messages as well.
    _conversationRepository.getConversations().listen(
      (conversations) {
        emit(state.copyWith(status: ConversationStatus.success, conversations: conversations));
      },
      onError: (error) {
        emit(state.copyWith(status: ConversationStatus.failure, exception: error));
      },
    );
  }

  final ConversationRepository _conversationRepository;
}
