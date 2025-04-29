import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/custom_text_field.dart';

// Forgot Password screen widget
class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to validate the form
  final _emailController = TextEditingController(); // Controller to handle email input
  bool _emailSent = false; // Flag to track if email has been sent

  @override
  void dispose() {
    _emailController.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  // Method to handle form submission
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return; // Validate form fields

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Trigger password reset using email
    final success = await authProvider.resetPassword(_emailController.text.trim());

    if (success && mounted) {
      // Update UI if reset was successful
      setState(() {
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Access AuthProvider
    final theme = Theme.of(context); // Get current theme

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey, // Attach form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
                // Title text
                Text(
                  'Forgot Password',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Conditional message based on email sent status
                Text(
                  _emailSent
                      ? 'Password reset link has been sent to your email.'
                      : 'Enter your email address to receive a password reset link.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                if (!_emailSent) ...[
                  // Email input field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hintText: 'Enter Email Address',
                    keyboardType: TextInputType.emailAddress,
                    prefix: const Icon(Icons.email_outlined), // Email icon
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Error message display if any
                  if (authProvider.error != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.error!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Submit button
                  AuthButton(
                    text: 'Send',
                    onPressed: _submit,
                    isLoading: authProvider.loading,
                  ),
                ],
                if (_emailSent) ...[
                  // Success icon
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  // Button to return to login screen
                  AuthButton(
                    text: 'Return to Login',
                    onPressed: () => Navigator.of(context).pop(),
                    isLoading: false,
                  ),
                  const SizedBox(height: 16),
                  // Option to try another email
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _emailSent = false;
                        });
                      },
                      child: Text(
                        'Try another email',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
