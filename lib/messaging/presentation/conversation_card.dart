import 'package:atmail/messaging/domain/app_conversation.dart';
import 'package:atmail/messaging/domain/message_content.dart';
import 'package:atmail/router/router.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flutter/material.dart';

class ConversationCard extends StatefulWidget {
  const ConversationCard({required this.conversation, super.key});

  final AppConversation conversation;

  @override
  ConversationCardState createState() => ConversationCardState();
}

class ConversationCardState extends State<ConversationCard> {
  AppConversation get conversation => widget.conversation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        ConversationDetailsRoute(conversation.id).push(context);
      },
      child: Container(
        padding: EdgeInsets.all(theme.appSpacing.medium),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                conversation.participants.join(', '),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            SizedBox(width: theme.appSpacing.medium),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conversation.subject, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  switch (conversation.latestMessage) {
                    TextContent(:final text) => Text(
                      text,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _ => SizedBox.shrink(),
                  },
                ],
              ),
            ),
            SizedBox(width: theme.appSpacing.medium),
            if (conversation.latestMessageDate != null)
              // TODO: Setup a timer to refresh the last message date.
              Expanded(
                child: Text(
                  conversation.lastMessageDateFormatted()!,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
                  textAlign: TextAlign.end,
                ),
              ),
            if (conversation.latestMessageDate == null) Spacer(),
          ],
        ),
      ),
    );
  }
}
