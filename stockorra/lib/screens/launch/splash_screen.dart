import 'package:flutter/material.dart';
import 'package:stockorra/screens/auth/login_screen.dart';

// Splash screen widget with state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentPage = 0; // Tracks current page in splash sequence
  final PageController _pageController = PageController(); // Controller for PageView navigation

  // Splash data containing title, subtitle, image, and optional button text
  final List<Map<String, String>> _splashData = [
    {
      "title": "STOCKORRA",
      "subtitle": "A PERFECT PLACE TO MANAGE YOUR INVENTORY",
      "image": "lib/assets/images/stockorra_logo.png",
    },
    {
      "title": "STOCKORRA",
      "subtitle": "Manage your inventory",
      "buttonText": "GET STARTED",
      "image": "lib/assets/images/stockorra_logo.png",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4D7D4D), // Background color of the splash screen
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController, // Page controller
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value; // Update current page index
                  });
                },
                itemCount: _splashData.length, // Number of pages
                itemBuilder: (context, index) => SplashContent(
                  title: _splashData[index]["title"]!,
                  subtitle: _splashData[index]["subtitle"]!,
                  image: _splashData[index]["image"]!,
                  showButton: index == _splashData.length - 1, // Show button only on the last page
                  buttonText: _splashData[index]["buttonText"],
                  onButtonPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()), // Navigate to login screen
                    );
                  },
                ),
              ),
            ),
            // Show dots only if not on the last page
            if (_currentPage < _splashData.length - 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _splashData.length,
                    (index) => buildDot(index: index), // Build progress dots
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget to build animated dots indicating current page
  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6, // Expand dot for active page
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// Stateless widget to represent individual splash page content.
class SplashContent extends StatelessWidget {
  final String title; // Page title
  final String subtitle; // Page subtitle
  final String image; // Image path
  final bool showButton; // Whether to show the button
  final String? buttonText; // Optional button text
  final VoidCallback? onButtonPressed; // Callback for button press

  const SplashContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.showButton = false,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF4D7D4D), // Page background color
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            image,
            height: 180,
            width: 180,
            color: Colors.white, // White-tinted logo
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
          if (showButton) ...[
            const SizedBox(height: 48),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 56,
              child: ElevatedButton(
                onPressed: onButtonPressed, // Call navigation callback
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4D7D4D), // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  buttonText ?? "GET STARTED", // Button label
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}
