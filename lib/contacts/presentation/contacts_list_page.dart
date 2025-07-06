import 'package:atmail/router/home_shell_route.dart';
import 'package:atmail/theme/form_factor.dart';
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
      drawer: (FormFactorWidget.of(context).showDrawer)
          ? Drawer(
              child: NavBar(),
            )
          : null,
    );
  }
}
