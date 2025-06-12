import 'dart:async';

import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversation_details_cubit.mapper.dart';

@MappableEnum()
enum ConversationDetailsStatus { loading, success, failure }

@MappableClass()
class ConversationDetailsState with ConversationDetailsStateMappable {
  const ConversationDetailsState({
    required this.status,
    this.conversation,
    this.exception,
  });

  final ConversationDetailsStatus status;
  final AppConversation? conversation;
  final Exception? exception;
}

class ConversationDetailsCubit extends Cubit<ConversationDetailsState> {
  ConversationDetailsCubit(
    this._conversationRepository, {
    required this.conversationId,
  }) : super(const ConversationDetailsState(status: ConversationDetailsStatus.loading)) {
    _init();
  }

  final AppConversationRepository _conversationRepository;
  final String conversationId;
  late final StreamSubscription<List<AppConversation>> _conversationSubscription;

  void _init() {
    _conversationSubscription = _conversationRepository.getConversations().listen(
      (conversations) {
        final conversation = conversations.firstWhereOrNull(
          (conv) => conv.id == conversationId,
        );

        if (conversation == null) {
          emit(
            state.copyWith(
              status: ConversationDetailsStatus.failure,
              exception: Exception('Conversation not found'),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ConversationDetailsStatus.success,
              conversation: conversation,
            ),
          );
        }
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: ConversationDetailsStatus.failure,
            exception: error is Exception ? error : Exception(error.toString()),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _conversationSubscription.cancel();
    return super.close();
  }
}
