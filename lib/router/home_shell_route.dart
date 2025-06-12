import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/repository/app_conversation_repository.impl.dart';
import 'package:atmail/router/router.dart';
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
    final int selectedIndex = getCurrentIndex(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppConversationRepository>(
          create: (context) => AppConversationRepositoryImpl(
            atClient: AtClientManager.getInstance().atClient,
            namespace: 'atmail',
          ),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                ConversationsRoute().go(context);
              case 1:
                ContactsListRoute().go(context);
              case 2:
                SettingsRoute().go(context);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'AtMail',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body: child,
      ),
    );
  }
}
