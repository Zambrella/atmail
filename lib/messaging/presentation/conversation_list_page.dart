import 'package:atmail/messaging/blocs/conversation_bloc.dart';
import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:atmail/messaging/presentation/conversation_list.dart';
import 'package:atmail/router/home_shell_route.dart';
import 'package:atmail/theme/form_factor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConversationCubit(
            context.read<AppConversationRepository>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Conversations'),
              centerTitle: false,
            ),
            drawer: (FormFactorWidget.of(context).showDrawer)
                ? Drawer(
                    child: NavBar(),
                  )
                : null,
            body: const ConversationList(),
          );
        },
      ),
    );
  }
}
