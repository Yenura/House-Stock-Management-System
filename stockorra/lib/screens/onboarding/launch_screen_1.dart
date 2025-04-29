import 'package:flutter/material.dart';

// LaunchScreen1 is a stateless widget that represents the first screen of the app
class LaunchScreen1 extends StatelessWidget {
  const LaunchScreen1({super.key});

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
            // Text widget displays a welcome message on the launch screen
            const Text(
              'Welcome to Stockorra', // Welcome message text
              style: TextStyle(
                fontSize: 24, // Font size of the text
                fontWeight: FontWeight.bold, // Bold text style
              ),
            ),
            const SizedBox(height: 20), // Adds space between the Text and the button
            // ElevatedButton is a button with an elevation shadow
            ElevatedButton(
              onPressed: () {
                // When the button is pressed, navigate to the '/launch2' route
                Navigator.pushNamed(context, '/launch2');
              },
              child: const Text('Next'), // Text displayed on the button
            ),
          ],
        ),
      ),
    );
  }
}
//.