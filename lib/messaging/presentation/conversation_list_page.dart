import 'package:atmail/messaging/presentation/conversation_list.dart';
import 'package:atmail/router/home_shell_route.dart';
import 'package:atmail/theme/form_factor.dart';
import 'package:flutter/material.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
