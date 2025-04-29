import 'package:flutter/material.dart';
import 'package:stockorra/routes.dart'; // Importing routes for navigation

// OnboardingScreens is a stateless widget that represents the onboarding screen of the app
class OnboardingScreens extends StatelessWidget {
  const OnboardingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    // The build method returns a Scaffold widget, which provides basic visual structure
    return Scaffold(
      body: SafeArea(
        // SafeArea ensures the UI elements don't overlap with system UI (e.g., status bar)
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Adds padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the children vertically
            children: [
              // Text widget displays the welcome message on the onboarding screen
              const Text(
                'Welcome to Stockorra', // Welcome message text
                style: TextStyle(
                  fontSize: 28, // Font size of the text
                  fontWeight: FontWeight.bold, // Bold text style
                ),
              ),
              const SizedBox(height: 40), // Adds space between the welcome text and the buttons
              // ElevatedButton is a button with an elevation shadow
              ElevatedButton(
                onPressed: () {
                  // When the button is pressed, navigate to the login screen
                  Navigator.pushReplacementNamed(context, Routes.login);
                },
                child: const Text('Login'), // Text displayed on the login button
              ),
              const SizedBox(height: 20), // Adds space between the buttons
              // ElevatedButton is a button with an elevation shadow
              ElevatedButton(
                onPressed: () {
                  // When the button is pressed, navigate to the sign-up screen
                  Navigator.pushReplacementNamed(context, Routes.signup);
                },
                child: const Text('Sign Up'), // Text displayed on the sign-up button
              ),
              const SizedBox(height: 20), // Adds space between the buttons
              // TextButton is a flat button that does not have an elevation shadow
              TextButton(
                onPressed: () {
                  // When the button is pressed, navigate to the forgot password screen
                  Navigator.pushReplacementNamed(
                      context, Routes.forgotPassword);
                },
                child: const Text('Forgot Password?'), // Text displayed on the forgot password button
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//.