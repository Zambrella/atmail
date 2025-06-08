import 'dart:async';

import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AtMail',
      routerConfig: goRouter(),
      builder: (_, child) {
        // Wrap with inherited widgets if needed.
        return AppStartupWidget(
          onLoaded: (_) => child!,
        );
      },
    );
  }
}

final logger = Logger('App');

class AppStartupWidget extends StatefulWidget {
  const AppStartupWidget({required this.onLoaded, super.key});

  final WidgetBuilder onLoaded;

  @override
  AppStartupWidgetState createState() => AppStartupWidgetState();
}

class AppDependencies {
  const AppDependencies({required this.atClientPreferences});

  final AtClientPreference atClientPreferences;
}

class AppStartupWidgetState extends State<AppStartupWidget> {
  late final Future<AppDependencies> _initialize;

  @override
  void initState() {
    super.initState();
    _initialize = _initialisation();
  }

  Future<AppDependencies> _initialisation() async {
    logger.fine('Starting initialization');
    // Atsign initialisation.
    final dir = await getApplicationSupportDirectory();
    final atClientPreference = AtClientPreference()
      ..rootDomain = 'root.atsign.org'
      ..namespace = dotenv.env['NAMESPACE']
      ..hiveStoragePath = dir.path
      ..commitLogPath = dir.path
      ..isLocalStoreRequired = true;
    final dependencies = AppDependencies(
      atClientPreferences: atClientPreference,
    );
    FlutterNativeSplash.remove();
    logger.fine('Initialization completed');
    return dependencies;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppDependencies>(
      future: _initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return RepositoryProvider<AppDependencies>.value(
          value: snapshot.data!,
          child: widget.onLoaded(context),
        );
      },
    );
  }
}
