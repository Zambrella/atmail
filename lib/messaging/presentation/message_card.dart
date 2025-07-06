import 'package:atmail/messaging/blocs/delete_message_cubit.dart';
import 'package:atmail/messaging/domain/app_message.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:atmail/messaging/presentation/message_context_dialog.dart';
import 'package:atmail/messaging/presentation/message_status_icon.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    required this.message,
    required this.isSender,
    super.key,
  });

  final AppMessage message;
  final bool isSender;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool _isHovered = false;

  Future<void> _showMessageContextMenu(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<DeleteMessageCubit>(),
          child: MessageContextDialog(message: widget.message, isSender: widget.isSender),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: theme.appSpacing.verySmall),
      child: Stack(
        children: [
          InkWell(
            onLongPress: () => _showMessageContextMenu(context),
            onHover: (hovering) {
              if (hovering != _isHovered) {
                setState(() {
                  _isHovered = hovering;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      if (widget.isSender)
                        Text(
                          'You',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      if (!widget.isSender)
                        Text(
                          widget.message.sender,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      SizedBox(width: theme.appSpacing.small),
                      // TODO: Setup a timer to refresh the message the card every 60 seconds if the message is within the last 60 minutes.
                      // So that the message timestamp is always up-to-date.
                      Tooltip(
                        message: DateFormat('yyyy-MM-dd HH:mm').format(widget.message.timestamp),
                        preferBelow: false,
                        verticalOffset: theme.appSpacing.small,
                        child: Text(
                          widget.message.dateFormatted(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(width: theme.appSpacing.small),
                      if (widget.isSender && widget.message.content is! DeletedContent)
                        MessageStatusIcon(status: widget.message.status),
                    ],
                  ),
                  SizedBox(height: theme.appSpacing.verySmall),
                  Flexible(
                    child: switch (widget.message.content) {
                      TextContent(:final text) => Text(text),
                      MarkdownContent() => throw UnimplementedError(),
                      BinaryContent() => throw UnimplementedError(),
                      DeletedContent() => Text('Message deleted'),
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isHovered)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.more_vert),
                onHover: (hovering) {
                  if (hovering != _isHovered) {
                    setState(() {
                      _isHovered = hovering;
                    });
                  }
                },
                onPressed: () => _showMessageContextMenu(context),
              ),
            ),
        ],
      ),
    );
  }
}
