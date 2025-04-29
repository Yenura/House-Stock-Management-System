// Importing Flutter's material UI package.
import 'package:flutter/material.dart';
// Importing custom route definitions from the stockorra app.
import 'package:stockorra/routes.dart';

// Defining a stateless widget named LaunchScreen2.
class LaunchScreen2 extends StatelessWidget {
  // Constructor with optional key.
  const LaunchScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic visual layout structure.
    return Scaffold(
      // Setting a light green background color for the screen.
      backgroundColor: const Color(0xFFE8F5E9),
      // Centering the main content vertically and horizontally.
      body: Center(
        child: Column(
          // Centering the children vertically.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the app logo from assets.
            Image.asset(
              'assets/images/stockorra_logo.png',
              width: 200,
              height: 200,
            ),
            // Adding vertical space.
            const SizedBox(height: 20),
            // Displaying the app name in bold text.
            const Text(
              'STOCKORRA',
              style: TextStyle(
                fontSize: 28, // Large font size for title.
                fontWeight: FontWeight.bold, // Bold text.
                color: Color(0xFF4D7D4D), // Dark green color.
              ),
            ),
            // More vertical spacing.
            const SizedBox(height: 40),
            // Displaying a short description text.
            const Text(
              'Manage your\nInventory smartly',
              textAlign: TextAlign.center, // Center-align the multiline text.
              style: TextStyle(
                fontSize: 24, // Medium-large font.
                color: Color(0xFF4D7D4D), // Dark green color.
                height: 1.5, // Line height for better spacing.
              ),
            ),
            // Even more vertical spacing before the button.
            const SizedBox(height: 60),
            // "Next" button to navigate to the next screen.
            ElevatedButton(
              onPressed: () {
                // Navigating to LaunchScreen3 and replacing the current screen.
                Navigator.pushReplacementNamed(context, Routes.launch3);
              },
              // Styling the button.
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D7D4D), // Green background.
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Button padding.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button edges.
                ),
              ),
              // Text inside the button.
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // White text color.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
