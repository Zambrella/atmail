import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/auth/presentation/onboarding_screen.dart';
import 'package:atmail/contacts/presentation/contacts_list_page.dart';
import 'package:atmail/messaging/presentation/conversation_list_page.dart';
import 'package:atmail/messaging/presentation/conversation_details_page.dart';
import 'package:atmail/router/error_screen.dart';
import 'package:atmail/router/home_shell_route.dart';
import 'package:atmail/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

part 'router.g.dart';

// Use singleton pattern to avoid hot reload issues
class _NavigatorKeys {
  static GlobalKey<NavigatorState>? _rootKey;
  static GlobalKey<NavigatorState>? _homeKey;

  static GlobalKey<NavigatorState> get rootNavigatorKey {
    return _rootKey ??= GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');
  }

  static GlobalKey<NavigatorState> get homeNavigatorKey {
    return _homeKey ??= GlobalKey<NavigatorState>(debugLabel: 'homeNavigator');
  }
}

final logger = Logger('Router');

final router = GoRouter(
  initialLocation: '/mail',
  navigatorKey: _NavigatorKeys.rootNavigatorKey,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    try {
      final atClient = AtClientManager.getInstance().atClient;

      if (atClient.getCurrentAtSign() == null) {
        return OnboardingRoute().location;
      }
    } catch (e, st) {
      if (e.toString() == 'Null check operator used on a null value') {
        return OnboardingRoute().location;
      }
      logger.severe('Error getting current atsign', e, st);

      rethrow;
    }

    return null;
  },
  routes: $appRoutes,
  errorBuilder: (BuildContext context, GoRouterState state) {
    return ErrorRoute(error: state.error!).build(context, state);
  },
);

extension GoRouterExtension on GoRouter {
  // Clear the stack and navigate to a new location
  void clearStackAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
}

@TypedShellRoute<HomeShellRouteData>(
  routes: [
    TypedGoRoute<ConversationsRoute>(
      path: '/mail',
      name: 'mail',
      routes: [
        TypedGoRoute<ConversationDetailsRoute>(
          path: ':conversationId',
          name: 'conversationDetails',
        ),
      ],
    ),
    TypedGoRoute<ContactsListRoute>(
      path: '/contacts',
      name: 'contactsList',
    ),
    TypedGoRoute<SettingsRoute>(
      path: '/settings',
      name: 'settings',
    ),
  ],
)
class HomeShellRouteData extends ShellRouteData {
  const HomeShellRouteData();

  static GlobalKey<NavigatorState> get $navigatorKey => _NavigatorKeys.homeNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return HomeShellRoute(child: navigator);
  }
}

class ConversationsRoute extends GoRouteData with _$ConversationsRoute {
  const ConversationsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConversationsPage();
  }
}

class ConversationDetailsRoute extends GoRouteData with _$ConversationDetailsRoute {
  const ConversationDetailsRoute(this.conversationId);

  final String conversationId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ConversationDetailsPage(conversationId: conversationId);
  }
}

class ContactsListRoute extends GoRouteData with _$ContactsListRoute {
  const ContactsListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ContactsListPage();
  }
}

class SettingsRoute extends GoRouteData with _$SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingsPage();
  }
}

@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
  name: 'onboarding',
)
class OnboardingRoute extends GoRouteData with _$OnboardingRoute {
  OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OnboardingScreen();
  }
}

class ErrorRoute extends GoRouteData {
  ErrorRoute({required this.error});

  final Exception error;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ErrorScreen(error: error);
  }
}
