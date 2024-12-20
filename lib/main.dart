import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/welcome.dart';
// ignore: unused_import
import 'welcome.dart'; // Import your welcome screen file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Mr Lowat Bakery',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Set your primary color theme
      ),
      home: const BakeryWelcomeScreen(), // Set your welcome screen as the home page
    );
  }
}
