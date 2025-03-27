import 'package:flutter/material.dart';

class LaunchScreen1 extends StatelessWidget {
  const LaunchScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your launch screen content here
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
                Navigator.pushNamed(context, '/launch2');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
