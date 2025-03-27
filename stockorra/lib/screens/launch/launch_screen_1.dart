import 'package:flutter/material.dart';
import 'package:stockorra/routes.dart';

class LaunchScreen1 extends StatelessWidget {
  const LaunchScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Stockorra',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.launch2);
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
