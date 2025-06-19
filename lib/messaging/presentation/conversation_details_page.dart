import 'package:atmail/messaging/blocs/conversation_details_cubit.dart';
import 'package:atmail/messaging/blocs/delete_conversation_cubit.dart';
import 'package:atmail/messaging/blocs/delete_message_cubit.dart';
import 'package:atmail/messaging/blocs/new_message_cubit.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/presentation/loaded_conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationDetailsPage extends StatefulWidget {
  const ConversationDetailsPage({required this.conversationId, super.key});

  final String conversationId;

  @override
  ConversationDetailsPageState createState() => ConversationDetailsPageState();
}

class ConversationDetailsPageState extends State<ConversationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationDetailsCubit(
        context.read<AppConversationRepository>(),
        conversationId: widget.conversationId,
      ),
      child: Builder(
        builder: (context) {
          return BlocConsumer<ConversationDetailsCubit, ConversationDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.status) {
                case ConversationDetailsStatus.loading:
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Center(child: CircularProgressIndicator()),
                  );
                case ConversationDetailsStatus.success when state.conversation != null:
                  final conversation = state.conversation!;
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => NewMessageCubit(
                          context.read<AppConversationRepository>(),
                          conversationId: conversation.id,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => DeleteMessageCubit(
                          context.read<AppConversationRepository>(),
                          conversationId: conversation.id,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => DeleteConversationCubit(
                          context.read<AppConversationRepository>(),
                        ),
                      ),
                    ],
                    child: LoadedConversation(conversation: conversation),
                  );
                case _:
                  return Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: Text(
                        state.exception.toString(),
                      ),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
