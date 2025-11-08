// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeShellRouteData, $onboardingRoute];

RouteBase get $homeShellRouteData => ShellRouteData.$route(
  navigatorKey: HomeShellRouteData.$navigatorKey,
  factory: $HomeShellRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/mail',
      name: 'mail',
      factory: $ConversationsRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: ':conversationId',
          name: 'conversationDetails',
          factory: $ConversationDetailsRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: '/contacts',
      name: 'contactsList',
      factory: $ContactsListRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/settings',
      name: 'settings',
      factory: $SettingsRoute._fromState,
    ),
  ],
);

extension $HomeShellRouteDataExtension on HomeShellRouteData {
  static HomeShellRouteData _fromState(GoRouterState state) =>
      const HomeShellRouteData();
}

mixin $ConversationsRoute on GoRouteData {
  static ConversationsRoute _fromState(GoRouterState state) =>
      const ConversationsRoute();

  @override
  String get location => GoRouteData.$location('/mail');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ConversationDetailsRoute on GoRouteData {
  static ConversationDetailsRoute _fromState(GoRouterState state) =>
      ConversationDetailsRoute(state.pathParameters['conversationId']!);

  ConversationDetailsRoute get _self => this as ConversationDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/mail/${Uri.encodeComponent(_self.conversationId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ContactsListRoute on GoRouteData {
  static ContactsListRoute _fromState(GoRouterState state) =>
      const ContactsListRoute();

  @override
  String get location => GoRouteData.$location('/contacts');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  name: 'onboarding',
  factory: $OnboardingRoute._fromState,
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) => OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
