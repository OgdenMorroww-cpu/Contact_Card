// ignore_for_file: prefer_const_constructors

import 'package:contact_card/screens/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("contact_box");
  runApp(ContactCard());
}

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Contact Card",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: ContactPage(),
    );
  }
}
