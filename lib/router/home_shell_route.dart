import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/auth/blocs/available_atsigns_cubit.dart';
import 'package:atmail/auth/domain/auth_repository.dart';
import 'package:atmail/auth/presentation/atsign_switcher.dart';
import 'package:atmail/auth/repository/auth_repository.impl.mock.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/repository/app_conversation_repository.impl.dart';
import 'package:atmail/router/router.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeShellRoute extends StatelessWidget {
  const HomeShellRoute({required this.child, super.key});

  final Widget child;

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(ConversationsRoute().location)) {
      return 0;
    } else if (location.startsWith(ContactsListRoute().location)) {
      return 1;
    } else if (location.startsWith(SettingsRoute().location)) {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = getCurrentIndex(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppConversationRepository>(
          create: (context) => AppConversationRepositoryImpl(
            atClient: AtClientManager.getInstance().atClient,
            namespace: 'atmail',
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => MockAuthRepositoryImpl(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: 250,
                  padding: EdgeInsets.all(theme.appSpacing.small),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'atMail',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(height: theme.appSpacing.small),
                      BlocProvider(
                        create: (context) => AvailableAtsignsCubit(
                          context.read<AuthRepository>(),
                        )..fetchAvailableAtsigns(),
                        child: AtsignSwitcher(),
                      ),
                      SizedBox(height: theme.appSpacing.large),
                      _NavigationItem(
                        key: ValueKey('conversations'),
                        title: 'Conversations',
                        selectedIcon: Icons.message,
                        unselectedIcon: Icons.message_outlined,
                        onTap: () {
                          ConversationsRoute().go(context);
                        },
                        isSelected: selectedIndex == 0,
                      ),
                      _NavigationItem(
                        key: ValueKey('contacts'),
                        title: 'Contacts',
                        selectedIcon: Icons.people,
                        unselectedIcon: Icons.people_outline,
                        onTap: () {
                          ContactsListRoute().go(context);
                        },
                        isSelected: selectedIndex == 1,
                      ),
                      _NavigationItem(
                        key: ValueKey('settings'),
                        title: 'Settings',
                        selectedIcon: Icons.settings,
                        unselectedIcon: Icons.settings_outlined,
                        onTap: () {
                          SettingsRoute().go(context);
                        },
                        isSelected: selectedIndex == 2,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'You have 20MB of storage left',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    required this.title,
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.onTap,
    required this.isSelected,
    this.iconCount = 0,
    super.key,
  });

  final String title;
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final int iconCount;

  @override
  _NavigationItemState createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = widget.isSelected ? widget.selectedIcon : widget.unselectedIcon;
    return Container(
      margin: EdgeInsets.only(bottom: theme.appSpacing.small),
      child: Material(
        color: widget.isSelected ? theme.colorScheme.primary.darken(20) : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.appSpacing.small),
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: theme.colorScheme.primary.darken(10),
          borderRadius: BorderRadius.circular(theme.appSpacing.small),
          child: AnimatedContainer(
            duration: theme.appDurations.quick,
            padding: EdgeInsets.symmetric(horizontal: theme.appSpacing.medium, vertical: theme.appSpacing.small),
            curve: Curves.easeInOut,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.onPrimary,
                ),
                SizedBox(width: theme.appSpacing.small),
                Text(
                  widget.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                Spacer(),
                if (widget.iconCount > 0)
                  Text(
                    '${widget.iconCount}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
