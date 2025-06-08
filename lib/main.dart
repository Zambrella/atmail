import 'dart:async';
import 'dart:developer';

import 'package:atmail/bootstrap.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      await bootstrap(binding);
    },
    (Object error, StackTrace? stack) {
      // Add any additional error handling logic here. E.g. Log to Crashlytics
      log(
        'runZonedGuarded: Caught error: $error',
        time: DateTime.now(),
        name: 'main',
        error: error,
        stackTrace: stack,
        level: 1000,
      );
    },
  );
}
