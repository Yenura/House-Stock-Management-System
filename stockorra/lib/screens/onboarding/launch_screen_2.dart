import 'package:flutter/material.dart';

class LaunchScreen2 extends StatelessWidget {
  const LaunchScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Manage Your Inventory',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/launch3');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
