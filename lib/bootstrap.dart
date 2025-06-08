import 'dart:async';

import 'package:atmail/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger('bootstrap');

/// Runs any necessary Flutter or Platform specific initialization code before calling `runApp`.
Future<void> bootstrap(WidgetsBinding widgetsBinding) async {
  // Set the logger level here.
  Logger.root.level = Level.ALL;

  logger.fine('Starting bootstrap');

  // Keep the splash screen until told to remove.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Turn off the # in the URLs on the web.
  usePathUrlStrategy();

  // Register error handlers. For more info, see:
  // https://docs.flutter.dev/testing/errors
  registerErrorHandlers();

  // Set all the shared preferences to be prefixed with app name
  SharedPreferences.setPrefix('atmail.');

  // Load environment variables from .env file
  await dotenv.load();

  // Android specific settings
  if (defaultTargetPlatform == TargetPlatform.android) {
    //* Sets edge-to-edge system UI mode on Android 12+
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: true,
      ),
    );
    await setOptimalDisplayMode();
  }

  logger.fine('Bootstrapping complete');

  runApp(const App());
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.warning(
      'Uncaught flutter error: ${details.exception}',
      details.exception,
      details.stack,
    );
  };

  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logger.severe('Platform error: $error', error, stack);
    return true;
  };

  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    logger.warning(
      'Error building widget: ${details.exception}',
      details.exception,
      details.stack,
    );
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    } else {
      return const ColoredBox(
        color: Colors.red,
        child: Text('An error occured rendering this element'),
      );
    }
  };
}

// Code taken from https://stackoverflow.com/questions/63631522/flutter-120fps-issue
/// Enables high refresh rate for devices where it was previously disabled
Future<void> setOptimalDisplayMode() async {
  final supported = await FlutterDisplayMode.supported;
  final active = await FlutterDisplayMode.active;

  final sameResolution =
      supported
          .where(
            (DisplayMode m) => m.width == active.width && m.height == active.height,
          )
          .toList()
        ..sort(
          (DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate),
        );

  final mostOptimalMode = sameResolution.isNotEmpty ? sameResolution.first : active;

  // This setting is per session.
  await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}
