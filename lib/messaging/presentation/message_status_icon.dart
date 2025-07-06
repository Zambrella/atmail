import 'package:atmail/messaging/domain/message_status.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flutter/material.dart';

class MessageStatusIcon extends StatefulWidget {
  const MessageStatusIcon({required this.status, super.key});

  final MessageStatus status;

  @override
  MessageStatusIconState createState() => MessageStatusIconState();
}

class MessageStatusIconState extends State<MessageStatusIcon> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: theme.textTheme.bodyMedium?.fontSize,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Tooltip(
          preferBelow: false,
          verticalOffset: theme.appSpacing.small,
          message: switch (widget.status) {
            MessageStatusPending() => 'Pending',
            MessageStatusSent() => 'Sent',
            MessageStatusDelivered() => 'Delivered',
            MessageStatusError(:final message) => 'Error: $message',
          },
          child: AnimatedSwitcher(
            duration: theme.appDurations.regular,
            child: switch (widget.status) {
              MessageStatusPending() => const CircularProgressIndicator(
                key: Key('pending'),
              ),
              MessageStatusSent() => Icon(
                Icons.check,
                color: theme.colorScheme.onSurfaceVariant,
                key: Key('sent'),
              ),
              MessageStatusDelivered() => Icon(
                Icons.check,
                color: theme.colorScheme.onSurface,
                key: Key('delivered'),
              ),
              MessageStatusError() => Icon(
                Icons.error,
                color: theme.colorScheme.error,
                key: Key('error'),
              ),
            },
          ),
        ),
      ),
    );
  }
}
