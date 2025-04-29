// Importing Flutter's material design library for UI components.
import 'package:flutter/material.dart';
// Importing custom route definitions from the stockorra app.
import 'package:stockorra/routes.dart';

// Defining a stateless widget called LaunchScreen1.
class LaunchScreen1 extends StatelessWidget {
  // Constructor for LaunchScreen1 with an optional key.
  const LaunchScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    // Building the UI using a Scaffold widget.
    return Scaffold(
      // Centering the content in the middle of the screen.
      body: Center(
        child: Column(
          // Aligning children vertically in the center of the column.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying a welcome message.
            const Text(
              'Welcome to Stockorra',
              style: TextStyle(
                fontSize: 24, // Font size of the text.
                fontWeight: FontWeight.bold, // Making the text bold.
              ),
            ),
            // Adding vertical space between the text and the button.
            const SizedBox(height: 20),
            // Creating a button to navigate to the next launch screen.
            ElevatedButton(
              onPressed: () {
                // Navigating to the second launch screen using a named route and replacing the current one.
                Navigator.pushReplacementNamed(context, Routes.launch2);
              },
              // Button label.
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
