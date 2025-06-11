import 'package:atmail/messaging/domain/app_conversation_repository.abs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewMessageDialog extends StatefulWidget {
  const NewMessageDialog({super.key});

  @override
  NewMessageDialogState createState() => NewMessageDialogState();
}

class NewMessageDialogState extends State<NewMessageDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _recipientController = TextEditingController();
  late final _messageController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    print('Sending message...');
    if (_formKey.currentState!.validate()) {
      // Basic validation passed
      final recipient = _recipientController.text.trim();
      final message = _messageController.text.trim();

      final conversation = await context.read<AppConversationRepository>().startConversation(
        withAtSign: recipient,
        initialMessage: message,
      );
      print('Conversation started : $conversation');

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SimpleDialog(
        title: const Text('New Message'),
        contentPadding: const EdgeInsets.all(24.0),
        children: [
          TextFormField(
            controller: _recipientController,
            decoration: const InputDecoration(
              labelText: 'Recipient',
              prefixText: '@',
              hintText: 'username',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a recipient';
              }
              if (value.trim().length < 2) {
                return 'Recipient must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'Message',
              hintText: 'Type your message here...',
              alignLabelWithHint: true,
            ),
            minLines: 1,
            maxLines: 6,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a message';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, size: 24),
                label: const Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
