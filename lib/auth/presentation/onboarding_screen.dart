import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/app.dart';
import 'package:atmail/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyApp')),
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () async {
              AtOnboardingResult onboardingResult = await AtOnboarding.onboard(
                context: context,
                config: AtOnboardingConfig(
                  atClientPreference: context.read<AppDependencies>().atClientPreferences,
                  rootEnvironment: RootEnvironment.Production,
                ),
              );
              if (context.mounted) {
                switch (onboardingResult.status) {
                  case AtOnboardingResultStatus.success:
                    ConversationsRoute().go(context);
                  case AtOnboardingResultStatus.error:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(backgroundColor: Colors.red, content: Text('An error has occurred')),
                    );
                  case AtOnboardingResultStatus.cancel:
                }
              }
            },
            child: const Text('Onboard an @sign'),
          ),
        ),
      ),
    );
  }
}
