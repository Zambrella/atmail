import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/home_screen.dart';
import 'package:atmail/onboarding/presentation/onboarding_screen.dart';
import 'package:atmail/router/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

final logger = Logger('Router');

GoRouter goRouter() {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
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
}

extension GoRouterExtension on GoRouter {
  // Clear the stack and navigate to a new location
  void clearStackAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
}

// Use a shell route to inject providers => https://pub.dev/documentation/go_router_builder/latest/
@TypedGoRoute<HomeRoute>(
  path: '/',
  name: 'home',
)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
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
