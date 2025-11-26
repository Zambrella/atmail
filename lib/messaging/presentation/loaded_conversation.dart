import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/messaging/blocs/archive_conversation_cubit.dart';
import 'package:atmail/messaging/blocs/delete_conversation_cubit.dart';
import 'package:atmail/messaging/blocs/leave_conversation_cubit.dart';
import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/presentation/message_card.dart';
import 'package:atmail/messaging/presentation/message_input_field.dart';
import 'package:atmail/theme/theme_extensions.dart';
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

  void _deleteConversation() {
    // TODO: Show confirmation dialog.
    context.read<DeleteConversationCubit>().deleteConversation();
  }

  void _archiveConversation() {
    context.read<ArchiveConversationCubit>().archiveConversation();
  }

  void _unarchiveConversation() {
    context.read<ArchiveConversationCubit>().unarchiveConversation();
  }

  void _leaveConversation() {
    context.read<LeaveConversationCubit>().leaveConversation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.subject,
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                conversation.participants.join(', '),
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Delete Conversation',
              icon: Icon(Icons.delete),
              onPressed: _deleteConversation,
            ),
            if (!conversation.hasLeft)
              IconButton(
                tooltip: 'Leave Conversation',
                icon: Icon(Icons.exit_to_app),
                onPressed: _leaveConversation,
              ),
            if (!conversation.isArchived)
              IconButton(
                tooltip: 'Archive Conversation',
                icon: Icon(Icons.archive),
                onPressed: _archiveConversation,
              ),
            if (conversation.isArchived)
              IconButton(
                tooltip: 'Unarchive Conversation',
                icon: Icon(Icons.unarchive),
                onPressed: _unarchiveConversation,
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: conversation.messages.length,
                reverse: true,
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
              padding: EdgeInsets.all(Theme.of(context).appSpacing.medium),
              constraints: BoxConstraints(
                maxHeight: 500,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: conversation.hasLeft ? Text('Conversation left') : MessageInputField(),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
