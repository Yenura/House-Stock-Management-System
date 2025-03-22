import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stockorra/firebase_options.dart';


//initialize firebase here
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Stock Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stockorra - Home'),
      ),
      body: const Center(
        child: Text(
          'Welcome to House Stock Management System!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
