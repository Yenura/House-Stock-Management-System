// Import Flutter and custom widgets
import 'package:flutter/material.dart';
import '../../widgets/auth/auth_button.dart';

// Screen to enter OTP for verification
class VerificationScreen extends StatefulWidget {
  static const routeName = '/verification';

  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // Controllers for OTP input fields
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  // Focus nodes to manage cursor movement between inputs
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );

  // Stores the OTP digits as they are entered
  final List<String> _otp = List.filled(4, '');

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Simple OTP verification logic
  void _verifyOtp() {
    final enteredOtp = _otp.join();
    // Proceed if OTP is 4 digits long
    if (enteredOtp.length == 4) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Show error message if OTP is incomplete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 16),
              // Title text
              Text(
                'Verification',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Instructional text
              Text(
                'We have sent verification code to your mobile number',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 60,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      // Automatically move focus to next input
                      onChanged: (value) {
                        if (value.length == 1) {
                          _otp[index] = value;
                          if (index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                            _verifyOtp(); // Auto-submit on final digit
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Manual verify button
              AuthButton(
                text: 'Verify',
                onPressed: _verifyOtp,
                isLoading: false,
              ),
              const SizedBox(height: 24),
              // Resend OTP button
              TextButton(
                onPressed: () {
                  // Simulate resend action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Code resent'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive code? ",
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Countdown timer (static text for now)
              Text(
                'You can resend code in 00:52',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
