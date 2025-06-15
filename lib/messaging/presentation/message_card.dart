import 'package:atmail/messaging/domain/app_message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    required this.message,
    required this.isSender,
    super.key,
  });

  final AppMessage message;
  final bool isSender;

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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isSender) Text(message.sender),
                    Flexible(
                      child: Text(message.content.toString()),
                    ),
                    if (isSender) Text(message.status.toString()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
