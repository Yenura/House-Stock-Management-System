import 'package:flutter/material.dart';

class LaunchScreen3 extends StatelessWidget {
  const LaunchScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Track Expiry Dates',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/onboarding');
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
