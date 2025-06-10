import 'package:atmail/messaging/blocs/conversation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationList extends StatefulWidget {
  const ConversationList({super.key});

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationCubit, ConversationState>(
      listener: (context, state) {
        if (state.status == ConversationStatus.failure) {
          // TODO: Show error message
        }
      },
      builder: (context, state) {
        if (state.status == ConversationStatus.loading && state.conversations.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          final conversations = state.conversations;
          if (conversations.isEmpty) {
            return Center(child: Text('No conversations'));
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ListTile(
                title: Text(conversation.participants.join(', ')),
              );
            },
          );
        }
      },
    );
  }
}
