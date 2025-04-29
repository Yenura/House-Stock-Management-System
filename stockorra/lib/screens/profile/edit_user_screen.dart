import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/models/user_model.dart'; // User model
import 'package:stockorra/providers/auth_provider.dart'; // Auth state management
import 'package:stockorra/utils/constants.dart'; // App-wide constants
import 'package:stockorra/utils/validators.dart'; // Input validation utilities
import 'package:stockorra/widgets/auth/auth_button.dart'; // Custom button widget
import 'package:stockorra/widgets/auth/custom_text_field.dart'; // Custom text field widget

// Screen to edit user details (admin or self-edit)
class EditUserScreen extends StatefulWidget {
  final User user; // User data passed to screen

  const EditUserScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to validate form
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _newPasswordController = TextEditingController(); // Optional password update
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    // Initialize with existing user values
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // Updates user information (with optional password change)
  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Prepare updated user data
      final updatedData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      };

      // Include password only if user typed something
      if (_newPasswordController.text.isNotEmpty) {
        updatedData['password'] = _newPasswordController.text.trim();
      }

      // Call provider to update the user
      await authProvider.updateUser(widget.user.id, updatedData);

      if (mounted) {
        Navigator.pop(context); // Go back to previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Handle error gracefully
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Handles user deletion after confirmation
  Future<void> _deleteUser() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.deleteUser(widget.user.id); // Call delete method

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editUser),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteUser, // Trigger delete logic
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Attach validation key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              CustomTextField(
                label: AppStrings.name,
                controller: _nameController,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),
              // Email field
              CustomTextField(
                label: AppStrings.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              // Optional password update
              CustomTextField(
                label: 'New ${AppStrings.password} (optional)',
                controller: _newPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // No password means no update
                  }
                  return Validators.validatePassword(value);
                },
              ),
              const SizedBox(height: 32),
              // Submit button
              AuthButton(
                text: 'Update User',
                onPressed: _updateUser,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
