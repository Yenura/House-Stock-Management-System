// Importing Flutter's material package for UI components.
import 'package:flutter/material.dart';
// Importing route definitions from the stockorra app.
import 'package:stockorra/routes.dart';

// Defining a stateless widget called LaunchScreen3.
class LaunchScreen3 extends StatelessWidget {
  // Constructor with optional key.
  const LaunchScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Scaffold to create the basic layout structure.
    return Scaffold(
      // Centering the content of the screen.
      body: Center(
        child: Column(
          // Aligning widgets vertically in the center of the column.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the title text.
            const Text(
              'Track Expiry Dates',
              style: TextStyle(
                fontSize: 24, // Font size of the text.
                fontWeight: FontWeight.bold, // Making the text bold.
              ),
            ),
            // Adding space between the text and button.
            const SizedBox(height: 20),
            // A button to proceed to the onboarding screen.
            ElevatedButton(
              onPressed: () {
                // Navigating to the onboarding screen and replacing this one.
                Navigator.pushReplacementNamed(context, Routes.onboarding);
              },
              // Label of the button.
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
//.