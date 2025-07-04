import 'dart:async';

import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/router/router.dart';
import 'package:atmail/theme/theme.dart';
import 'package:atmail/theme/theme_cubit.dart';
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
  late final ThemeCubit _themeCubit;
  late final StreamSubscription _themeSubscription;

  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _themeCubit = ThemeCubit();
    _themeSubscription = _themeCubit.stream.listen((theme) {
      setState(() {
        _themeMode = theme;
      });
    });
  }

  @override
  void dispose() {
    _themeSubscription.cancel();
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AtMail',
      routerConfig: router,
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      builder: (_, child) {
        // Wrap with inherited widgets if needed.
        return BlocProvider.value(
          value: _themeCubit,
          child: AppStartupWidget(
            onLoaded: (_) => child!,
          ),
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
  late FormFactor formFactor;

  @override
  void initState() {
    super.initState();
    _initialize = _initialisation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formFactor = getFormFactor(context);
  }

  /// Helper method to get form factor based on width of device
  static FormFactor getFormFactor(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    if (mediaQueryWidth <= FormFactor.mobile.breakpoint) {
      return FormFactor.mobile;
    } else if (mediaQueryWidth <= FormFactor.laptop.breakpoint) {
      return FormFactor.tablet;
    } else if (mediaQueryWidth <= FormFactor.desktop.breakpoint) {
      return FormFactor.laptop;
    } else {
      return FormFactor.desktop;
    }
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
    return TextScaleFactorClamper(
      child: FormFactorWidget(
        formFactor: formFactor,
        child: FutureBuilder<AppDependencies>(
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
        ),
      ),
    );
  }
}
