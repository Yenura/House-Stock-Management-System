import 'package:flutter/material.dart';

// LaunchScreen3 is a stateless widget that represents the third screen of the app
class LaunchScreen3 extends StatelessWidget {
  const LaunchScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    // The build method returns a Scaffold widget, which provides basic visual structure
    return Scaffold(
      body: Center(
        // Center widget centers its child within the screen
        child: Column(
          // Column arranges its children vertically
          mainAxisAlignment: MainAxisAlignment.center, // Center the children vertically
          children: [
            // Text widget displays a message to track expiry dates
            const Text(
              'Track Expiry Dates', // Text indicating tracking of expiry dates
              style: TextStyle(
                fontSize: 24, // Font size of the text
                fontWeight: FontWeight.bold, // Bold text style
              ),
            ),
            const SizedBox(height: 20), // Adds space between the Text and the button
            // ElevatedButton is a button with an elevation shadow
            ElevatedButton(
              onPressed: () {
                // When the button is pressed, navigate to the '/onboarding' route
                Navigator.pushNamed(context, '/onboarding');
              },
              child: const Text('Get Started'), // Text displayed on the button
            ),
          ],
        ),
      ),
    );
  }
}
//.