import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stockorra/screens/launch/onboarding_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
 name: "dev project",
 options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); // Using 'super.key' to pass the key to the superclass constructor

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
      home: const DashboardScreen(),
    );
  }
}