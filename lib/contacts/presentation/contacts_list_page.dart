import 'package:flutter/material.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});
  @override
  ContactsListPageState createState() => ContactsListPageState();
}

class ContactsListPageState extends State<ContactsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
    );
  }
}
