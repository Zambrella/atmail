import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/app.dart';
import 'package:atmail/router/router.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 800,
              ),
              child: Padding(
                padding: EdgeInsets.all(theme.appSpacing.medium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        style: theme.textTheme.displayLarge,
                        children: [
                          TextSpan(
                            text: 'At',
                          ),
                          TextSpan(
                            text: 'Mail',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: theme.appSpacing.small),
                    Text(
                      'End to end encrypted messaging platform',
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.appSpacing.veryLarge),
                    SizedBox(
                      height: 200,
                      child: Placeholder(),
                    ),
                    SizedBox(height: theme.appSpacing.veryLarge),
                    PrimaryTextButton(
                      isLoading: false,
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
                              final saveResult = await KeyChainManager.getInstance().makeAtSignPrimary(
                                onboardingResult.atsign!,
                              );
                              if (context.mounted) {
                                if (saveResult) {
                                  ConversationsRoute().go(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(backgroundColor: Colors.red, content: Text('Failed to save @sign')),
                                  );
                                }
                              }
                            case AtOnboardingResultStatus.error:
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(backgroundColor: Colors.red, content: Text('An error has occurred')),
                              );
                            case AtOnboardingResultStatus.cancel:
                              break;
                          }
                        }
                      },
                      text: 'Get Started',
                    ),
                    SizedBox(height: theme.appSpacing.medium),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Built on the ',
                          ),
                          TextSpan(
                            text: '@Platform',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = Uri.parse(
                                  'https://atsign.com/resources/white-papers/a-brief-overview-of-the-platform/',
                                );
                                await launchUrl(url);
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(theme.appSpacing.small),
              child: Text(
                'Version ${context.read<AppDependencies>().packageInfo.version}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
