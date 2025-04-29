import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/models/user_model.dart';
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/utils/validators.dart';
import 'package:stockorra/widgets/auth/auth_button.dart';
import 'package:stockorra/widgets/auth/custom_text_field.dart';

// Screen for adding a new household user (admin feature)
class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _nameController = TextEditingController(); // Name input
  final _emailController = TextEditingController(); // Email input
  final _passwordController = TextEditingController(); // Password input
  bool _isLoading = false; // UI loading state

  @override
  void dispose() {
    // Dispose controllers when widget is removed from tree
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle user creation logic
  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // If validation fails, do not proceed
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Create a new User model (Firebase will assign ID)
      final newUser = User(
        id: '',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        roles: ['household_member'],
      );

      // Call provider method to add user
      final success = await authProvider.addHouseholdMember(
        newUser,
        _passwordController.text,
      );

      if (success && mounted) {
        // Navigate back and show success message
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        // Display error from provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${authProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Handle unexpected exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Access provider

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addUser), // Title from constants
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Attach form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile icon with camera button (image picker not implemented)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      onPressed: () {
                        // TODO: Implement image picker
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Name input field
              CustomTextField(
                label: AppStrings.name,
                controller: _nameController,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),
              // Email input field
              CustomTextField(
                label: AppStrings.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              // Password input field
              CustomTextField(
                label: AppStrings.password,
                controller: _passwordController,
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 32),
              // Submit button
              AuthButton(
                text: 'Add User',
                onPressed: () => authProvider.loading ? null : _addUser(),
                isLoading: _isLoading || authProvider.loading,
              ),
              // Show error text if any
              if (authProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
