import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/app.dart';
import 'package:atmail/messaging/blocs/conversation_bloc.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/repository/app_conversation_repository.impl.dart';
import 'package:atmail/messaging/presentation/conversation_list.dart';
import 'package:atmail/messaging/presentation/new_message_dialog.dart';
import 'package:atmail/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// * Once the onboarding process is completed you will be taken to this screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppConversationRepository>(
          create: (context) => AppConversationRepositoryImpl(
            atClient: AtClientManager.getInstance().atClient,
            namespace: 'atmail',
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => ConversationCubit(
          context.read<AppConversationRepository>(),
        ),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Conversations'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      final resetResult = await AtOnboarding.reset(
                        context: context,
                        config: AtOnboardingConfig(
                          atClientPreference: context.read<AppDependencies>().atClientPreferences,
                          rootEnvironment: RootEnvironment.Production,
                        ),
                      );
                      switch (resetResult) {
                        case AtOnboardingResetResult.cancelled:
                        // Do nothing
                        case AtOnboardingResetResult.success:
                          if (context.mounted) {
                            OnboardingRoute().go(context);
                          }
                      }
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      return RepositoryProvider.value(
                        value: context.read<AppConversationRepository>(),
                        child: NewMessageDialog(),
                      );
                    },
                  );
                },
                child: Icon(Icons.message),
              ),
              body: const ConversationList(),
            );
          },
        ),
      ),
    );
  }
}
