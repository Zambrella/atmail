import 'package:atmail/messaging/blocs/conversation_details_cubit.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
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
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        conversation.participants.join(', '),
                      ),
                    ),
                    body: ListView.builder(
                      itemCount: conversation.messages.length,
                      itemBuilder: (context, index) {
                        final message = conversation.messages[index];
                        return ListTile(
                          title: Text(message.text),
                          subtitle: Text(message.sender),
                        );
                      },
                    ),
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
