import 'package:flutter/material.dart';
import 'package:stockorra/screens/launch/onboarding_screens.dart'; // Ensure this path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Using 'super.key' to pass the key to the superclass constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockorra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF4D7D4D),
        scaffoldBackgroundColor: const Color(0xFFF5F8F5),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(), // Ensure this class name matches the one in onboarding_screens.dart
    );
  }
}
