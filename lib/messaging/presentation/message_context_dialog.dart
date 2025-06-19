import 'package:atmail/messaging/blocs/delete_message_cubit.dart';
import 'package:atmail/messaging/domain/app_message.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageContextDialog extends StatefulWidget {
  const MessageContextDialog({
    required this.message,
    required this.isSender,
    super.key,
  });

  final AppMessage message;
  final bool isSender;

  @override
  MessageContextDialogState createState() => MessageContextDialogState();
}

class MessageContextDialogState extends State<MessageContextDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteMessageCubit, DeleteMessageState>(
      listener: (context, state) {
        switch (state) {
          case DeleteMessageStateSuccess():
            Navigator.of(context).pop();
          case DeleteMessageStateFailure(:final errorMessage):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete message: $errorMessage')),
            );
          case _:
            break;
        }
      },
      child: ListView(
        children: [
          if (widget.isSender && widget.message.content is! DeletedContent)
            ListTile(
              title: Text('Delete'),
              onTap: () {
                context.read<DeleteMessageCubit>().deleteMessage(widget.message, false);
              },
            ),
          if (widget.isSender && widget.message.content is! DeletedContent)
            ListTile(
              title: Text('Delete quietly'),
              onTap: () {
                context.read<DeleteMessageCubit>().deleteMessage(widget.message, true);
              },
            ),
        ],
      ),
    );
  }
}
