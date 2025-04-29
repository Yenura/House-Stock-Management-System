import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/models/user_model.dart'; // Import the User model from your project
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/utils/validators.dart';
import 'package:stockorra/widgets/auth/auth_button.dart';
import 'package:stockorra/widgets/auth/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// EditUserScreen widget for editing user details
class EditUserScreen extends StatefulWidget {
  final User user; // The user object to be edited

  const EditUserScreen({
    super.key,
    required this.user, // Passing the user to the screen
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key to validate form
  final _nameController = TextEditingController(); // Controller for name input field
  final _emailController = TextEditingController(); // Controller for email input field
  final _newPasswordController = TextEditingController(); // Controller for new password input field
  final _countryController = TextEditingController(); // Controller for country input field
  DateTime? _selectedDate; // Selected date of birth
  String? _photoUrl; // User's profile photo URL
  bool _isLoading = false; // Loading state for the update operation

  @override
  void initState() {
    super.initState();
    // Initializing controllers with existing user data
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _countryController.text = widget.user.country ?? '';
    _selectedDate = widget.user.dateOfBirth != null
        ? DateTime.parse(widget.user.dateOfBirth!) // Parse date of birth if exists
        : null;
    _photoUrl = widget.user.photoUrl; // Set the user's profile photo
  }

  @override
  void dispose() {
    // Dispose controllers when the screen is removed from the widget tree
    _nameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // Function to select the date of birth using a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked; // Set the selected date
      });
    }
  }

  // Function to update the user details in Firestore
  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // Return if form is not valid
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false); // Get auth provider

      // Build the map of updated fields
      final updatedData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'country': _countryController.text.trim(),
        'dateOfBirth': _selectedDate?.toIso8601String(),
        'photoUrl': _photoUrl,
      };

      // Include password if provided
      if (_newPasswordController.text.isNotEmpty) {
        updatedData['password'] = _newPasswordController.text.trim();
      }

      // Update user in Firestore
      await authProvider.updateUser(widget.user.id, updatedData);

      if (mounted) {
        Navigator.pop(context); // Pop screen after update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator in case of error
      });

      // Show error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to delete the user
  Future<void> _deleteUser() async {
    // Show confirmation dialog before deleting
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text(
            'Are you sure you want to delete this user? This action cannot be undone.'),
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

    if (confirm != true) {
      return; // Do nothing if deletion is canceled
    }

    setState(() {
      _isLoading = true; // Show loading indicator during deletion
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false); // Get auth provider

      await authProvider.deleteUser(widget.user.id); // Delete user from Firestore

      if (mounted) {
        Navigator.pop(context); // Pop screen after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator in case of error
      });

      // Show error message if deletion fails
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
        actions: [
          // Icon button for deleting the user
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteUser,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Attach the form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture and camera icon to change photo
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                      child: _photoUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Implement image picker
                        },
                      ),
                    ),
                  ],
                ),
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
              // New password input field (optional)
              CustomTextField(
                label: 'New ${AppStrings.password} (optional)',
                controller: _newPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Password is optional when updating
                  }
                  return Validators.validatePassword(value);
                },
              ),
              const SizedBox(height: 16),
              // Country input field
              CustomTextField(
                label: 'Country',
                controller: _countryController,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),
              // Date picker for selecting date of birth
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select Date',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Button to update the user
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
//.