import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


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
