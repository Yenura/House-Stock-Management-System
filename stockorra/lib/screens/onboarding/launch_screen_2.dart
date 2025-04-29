import 'package:flutter/material.dart';

// LaunchScreen2 is a stateless widget that represents the second screen of the app
class LaunchScreen2 extends StatelessWidget {
  const LaunchScreen2({super.key});

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
            // Text widget displays a message to manage inventory
            const Text(
              'Manage Your Inventory', // Text indicating inventory management
              style: TextStyle(
                fontSize: 24, // Font size of the text
                fontWeight: FontWeight.bold, // Bold text style
              ),
            ),
            const SizedBox(height: 20), // Adds space between the Text and the button
            // ElevatedButton is a button with an elevation shadow
            ElevatedButton(
              onPressed: () {
                // When the button is pressed, navigate to the '/launch3' route
                Navigator.pushNamed(context, '/launch3');
              },
              child: const Text('Next'), // Text displayed on the button
            ),
          ],
        ),
      ),
    );
  }
}
