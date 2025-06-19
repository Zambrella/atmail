import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/messaging/blocs/conversation_archive_cubit.dart';
import 'package:atmail/messaging/blocs/delete_conversation_cubit.dart';
import 'package:atmail/messaging/blocs/new_message_cubit.dart';
import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/presentation/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoadedConversation extends StatefulWidget {
  const LoadedConversation({required this.conversation, super.key});

  final AppConversation conversation;

  @override
  LoadedConversationState createState() => LoadedConversationState();
}

class LoadedConversationState extends State<LoadedConversation> {
  late AppConversation conversation;
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
  }

  @override
  void didUpdateWidget(LoadedConversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversation != widget.conversation) {
      conversation = widget.conversation;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() {
    if (_formKey.currentState?.validate() ?? false) {
      final messageText = _messageController.text.trim();

      context.read<NewMessageCubit>().addMessage(messageText);

      // Clear the text field after successful submission
      _messageController.clear();
    }
  }

  void _deleteConversation() {
    // TODO: Show confirmation dialog.
    context.read<DeleteConversationCubit>().deleteConversation();
  }

  void _archiveConversation() {
    context.read<ConversationArchiveCubit>().archiveConversation();
  }

  void _unarchiveConversation() {
    context.read<ConversationArchiveCubit>().unarchiveConversation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Lift this widget up to main conversation details screen
    return BlocListener<DeleteConversationCubit, DeleteConversationState>(
      listener: (context, state) {
        switch (state) {
          case DeleteConversationInitial():
            break;
          case DeleteConversationLoading():
            break;
          case DeleteConversationSuccess():
            context.pop();
          case DeleteConversationFailure(:final message):
            print(message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            conversation.participants.join(', '),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteConversation,
            ),
            if (!conversation.isArchived)
              IconButton(
                icon: Icon(Icons.archive),
                onPressed: _archiveConversation,
              ),
            if (conversation.isArchived)
              IconButton(
                icon: Icon(Icons.unarchive),
                onPressed: _unarchiveConversation,
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: conversation.messages.length,
                itemBuilder: (context, index) {
                  final message = conversation.messages[index];
                  return MessageCard(
                    message: message,
                    isSender: AtClientManager.getInstance().atClient.getCurrentAtSign() == message.sender,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: conversation.isArchived
                  ? Text('Conversation archived')
                  : Form(
                      key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _messageController,
                              maxLines: null,
                              minLines: 1,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                hintText: 'Type your message...',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a message';
                                }
                                if (value.trim().length > 1000) {
                                  return 'Message is too long (max 1000 characters)';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            onPressed: _submitMessage,
                            icon: const Icon(Icons.send),
                            tooltip: 'Send message',
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
