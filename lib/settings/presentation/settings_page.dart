import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Text(
            'You are: ${AtClientManager.getInstance().atClient.getCurrentAtSign()}',
          ),
        ],
      ),
    );
  }
}
