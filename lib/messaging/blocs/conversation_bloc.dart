import 'dart:async';

import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversation_bloc.mapper.dart';

@MappableEnum()
enum ConversationStatus { loading, success, failure }

@MappableClass()
class ConversationState with ConversationStateMappable {
  const ConversationState({
    required this.status,
    required this.conversations,
    this.exception,
  });

  final ConversationStatus status;
  final List<AppConversation> conversations;
  final Exception? exception;
}

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit(this._conversationRepository)
    : super(ConversationState(status: ConversationStatus.loading, conversations: [])) {
    _init();
  }

  final AppConversationRepository _conversationRepository;
  late final StreamSubscription<List<AppConversation>> _conversationSubscription;

  void _init() async {
    _conversationSubscription = _conversationRepository.getConversations().listen(
      (conversations) {
        emit(state.copyWith(status: ConversationStatus.success, conversations: conversations));
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: ConversationStatus.failure,
            exception: error is Exception ? error : Exception(error.toString()),
          ),
        );
      },
    );
  }

  void refresh() {
    // TODO: Add refresh method to repository.
  }

  @override
  Future<void> close() async {
    await _conversationSubscription.cancel();
    return super.close();
  }
}
