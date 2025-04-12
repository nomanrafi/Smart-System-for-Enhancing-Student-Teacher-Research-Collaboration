import 'package:flutter/material.dart';
import 'welcome.dart'; // Import the WelcomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(), // Use the WelcomeScreen from welcome.dart
    );
  }
}
