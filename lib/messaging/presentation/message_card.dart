import 'package:atmail/messaging/blocs/delete_message_cubit.dart';
import 'package:atmail/messaging/domain/app_message.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:atmail/messaging/presentation/message_context_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    required this.message,
    required this.isSender,
    super.key,
  });

  final AppMessage message;
  final bool isSender;

  Future<void> _showMessageContextMenu(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<DeleteMessageCubit>(),
          child: MessageContextDialog(message: message, isSender: isSender),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
            ),
            child: Card(
              child: InkWell(
                onLongPress: () => _showMessageContextMenu(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isSender) Text(message.sender),
                      Flexible(
                        child: switch (message.content) {
                          TextContent(:final text) => Text(text),
                          MarkdownContent() => throw UnimplementedError(),
                          BinaryContent() => throw UnimplementedError(),
                          DeletedContent() => Text('Message deleted'),
                        },
                      ),
                      if (isSender && message.content is! DeletedContent) Text(message.status.toString()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
