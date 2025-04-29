// Import necessary Flutter and package dependencies
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/social_login_button.dart';
import '../../widgets/auth/custom_text_field.dart';
import 'verification_screen.dart';

// SignUpScreen allows users to register using email/password or social login
class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _nameController = TextEditingController(); // Controller for full name input
  final _emailController = TextEditingController(); // Controller for email input
  final _passwordController = TextEditingController(); // Controller for password input
  bool _passwordVisible = false; // Toggles password visibility

  @override
  void dispose() {
    // Dispose controllers to release memory
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handles form submission
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return; // Validate form inputs

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Attempt to sign up with entered credentials
    final success = await authProvider.signUpWithEmailAndPassword(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    // If sign-up is successful, navigate to the verification screen
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(VerificationScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Access auth provider
    final theme = Theme.of(context); // Access app theme

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
                // Title
                Text(
                  'Sign Up',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // Full name input
                CustomTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  hintText: 'Full Name',
                  prefix: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email input
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  hintText: 'Email',
                  prefix: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password input with toggle visibility
                CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hintText: 'Password',
                  prefix: const Icon(Icons.lock_outline),
                  obscureText: !_passwordVisible,
                  suffix: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Display error message if signup fails
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
                // Sign Up button
                AuthButton(
                  text: 'Sign Up',
                  onPressed: _submit,
                  isLoading: authProvider.loading,
                ),
                const SizedBox(height: 24),
                // Divider with label
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or continue with',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                // Social sign-up buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialLoginButton(
                      text: 'Google',
                      iconPath: 'assets/icons/google.png',
                      onTap: () async {
                        final success = await authProvider.signInWithGoogle();
                        if (success && mounted) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                      },
                    ),
                    SocialLoginButton(
                      text: 'Facebook',
                      iconPath: 'assets/icons/facebook.png',
                      onTap: () async {
                        final success = await authProvider.signInWithFacebook();
                        if (success && mounted) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                      },
                    ),
                    SocialLoginButton(
                      text: 'Apple',
                      iconPath: 'assets/icons/apple.png',
                      onTap: () async {
                        final success = await authProvider.signInWithApple();
                        if (success && mounted) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                      },
                    ),
                  ],
                ),
                const Spacer(),
                // Link to navigate to login screen
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
