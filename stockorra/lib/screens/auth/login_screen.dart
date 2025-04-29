import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/social_login_button.dart';
import '../../widgets/auth/custom_text_field.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

// LoginScreen is a StatefulWidget to manage form state and visibility toggles
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to validate form fields
  final _emailController = TextEditingController(); // Controller for email input
  final _passwordController = TextEditingController(); // Controller for password input
  bool _passwordVisible = false; // Toggles password visibility

  @override
  void dispose() {
    // Dispose of controllers to free resources
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handles form submission
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return; // Validate inputs

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Attempt login with provided credentials
    final success = await authProvider.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // If login successful, navigate to home screen
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Access auth state
    final theme = Theme.of(context); // Access app theme

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey, // Assign form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Back button to navigate to previous screen
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
                // Title text
                Text(
                  "Let's get you in",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Email input field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  prefix: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
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

                const SizedBox(height: 16),
                
                // Password input field with toggle visibility
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Enter your password',
                  prefix: const Icon(Icons.lock_outline),
                  obscureText: !_passwordVisible,
                  suffix: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // Link to forgot password screen
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Display error message if login fails
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

                // Login button
                AuthButton(
                  text: 'Log In',
                  onPressed: _submit,
                  isLoading: authProvider.loading,
                ),

                const SizedBox(height: 24),

                // Divider with "or continue with" label
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

                // Row of social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialLoginButton(
                      iconPath: 'assets/icons/google.png',
                      text: 'Google',
                      onTap: () async {
                        final success = await authProvider.signInWithGoogle();
                        if (success && mounted) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                      },
                    ),
                    SocialLoginButton(
                      iconPath: 'assets/icons/facebook.png',
                      text: 'Facebook',
                      onTap: () async {
                        final success = await authProvider.signInWithFacebook();
                        if (success && mounted) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                      },
                    ),
                    SocialLoginButton(
                      iconPath: 'assets/icons/apple.png',
                      text: 'Apple',
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

                // Link to sign up screen
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sign up',
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
