import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/models/user_model.dart';
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/utils/validators.dart';
import 'package:stockorra/widgets/auth/auth_button.dart';
import 'package:stockorra/widgets/auth/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to identify the form
  final _nameController = TextEditingController(); // Controller for the name field
  final _emailController = TextEditingController(); // Controller for the email field
  final _passwordController = TextEditingController(); // Controller for the password field
  final _countryController = TextEditingController(); // Controller for the country field
  DateTime? _selectedDate; // Variable to hold the selected date of birth
  String? _photoUrl; // Variable to hold the user's photo URL
  bool _isLoading = false; // Flag to manage loading state

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // Method to allow the user to select a date for the date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Method to handle adding a new user
  Future<void> _addUser() async {
    // Validate form inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false); // Get AuthProvider instance

      // Create a new User model from input data
      final newUser = User(
        id: '', // ID will be filled by Firebase
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        roles: ['household_member'],
        photoUrl: _photoUrl,
        dateOfBirth: _selectedDate?.toIso8601String(),
        country: _countryController.text.trim(),
      );

      // Attempt to add the new user via AuthProvider
      final success = await authProvider.addHouseholdMember(
        newUser,
        _passwordController.text, // Password input
      );

      if (success && mounted) {
        Navigator.pop(context); // Close the screen on success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        // Show error if user creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${authProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Handle unexpected errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Hide loading state after operation is complete
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Get AuthProvider instance

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addUser), // AppBar title
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Padding for the body
        child: Form(
          key: _formKey, // Link form key to the form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl!) : null,
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
                        // TODO: Implement image picker for photo URL
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: AppStrings.name,
                controller: _nameController,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.password,
                controller: _passwordController,
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Country',
                controller: _countryController,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context), // Open date picker on tap
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
                            : 'Select Date', // Display selected date or prompt to select a date
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AuthButton(
                text: 'Add User',
                onPressed: () => authProvider.loading ? null : _addUser(), // Call _addUser method on button press
                isLoading: _isLoading || authProvider.loading, // Show loading state if necessary
              ),
              if (authProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center, // Show error message from auth provider
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
