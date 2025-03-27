import 'package:flutter/material.dart';
import 'package:stockorra/routes.dart';

class LaunchScreen2 extends StatelessWidget {
  const LaunchScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/stockorra_logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'STOCKORRA',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D7D4D),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Manage your\nInventory smartly',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF4D7D4D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.launch3);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D7D4D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
