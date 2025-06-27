import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flutter/material.dart';

class AtsignSwitcher extends StatefulWidget {
  const AtsignSwitcher({super.key});

  @override
  AtsignSwitcherState createState() => AtsignSwitcherState();
}

class AtsignSwitcherState extends State<AtsignSwitcher> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atSign = AtClientManager.getInstance().atClient.getCurrentAtSign();
    return Card(
      elevation: 0,
      // surfaceTintColor: theme.colorScheme.surfaceContainerHighest,
      color: theme.colorScheme.secondaryContainer,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(theme.appSpacing.small),
          child: Row(
            children: [
              Text(
                atSign ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              SizedBox(width: theme.appSpacing.verySmall),
              Spacer(),
              Icon(
                Icons.arrow_drop_down,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
