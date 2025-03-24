import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); // Using 'super.key' to pass the key to the superclass constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          const DashboardScreen(), // Ensure this class name matches the one in onboarding_screens.dart
    );
  }
}
