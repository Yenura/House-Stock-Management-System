// Importing the Flutter material package to use material design widgets.
import 'package:flutter/material.dart';

// Defining a stateless widget named NotificationsScreen.
class NotificationsScreen extends StatelessWidget {
  // Constructor for NotificationsScreen with an optional key.
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The build method describes how to display this widget using other widgets.
    return Scaffold(
      // Scaffold provides a structure with an app bar and a body.
      appBar: AppBar(
        // Setting the title of the app bar.
        title: const Text('Notifications'),
        // Setting a custom background color for the app bar using a hex color code.
        backgroundColor: const Color(0xFF4D7D4D),
      ),
      // Defining the main content of the screen.
      body: const Center(
        // Displaying text in the center of the screen.
        child: Text('Notifications Screen'),
      ),
    );
  }
}
