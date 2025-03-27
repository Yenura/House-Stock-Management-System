import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/models/user_model.dart'; // Import the User model from your project
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/utils/validators.dart';
import 'package:stockorra/widgets/auth/auth_button.dart';
import 'package:stockorra/widgets/auth/custom_text_field.dart';

class EditUserScreen extends StatefulWidget {
  final User user;
  
  const EditUserScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _newPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // Future<void> _updateUser() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
    
  //   setState(() {
  //     _isLoading = true;
  //   });
    
  //   try {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
  //     // Creating updated user using the provided User model
  //     final updatedUser = widget.user.copyWith(
  //       name: _nameController.text.trim(),
  //       email: _emailController.text.trim(),
  //     );
      
  //     // Using the original method names from the error messages
  //     await authProvider.updateHouseholdMember(
  //       updatedUser,
  //       _newPasswordController.text.isEmpty ? null : _newPasswordController.text,
  //     );
      
  //     if (mounted) {
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('User updated successfully'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
      
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> _updateUser() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Build the map of updated fields
    final updatedData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
    };

    // Include password if provided
    if (_newPasswordController.text.isNotEmpty) {
      updatedData['password'] = _newPasswordController.text.trim(); // Optional: handle password update logic
    }

    await authProvider.updateUser(widget.user.id, updatedData);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated successfully'),
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


  // Future<void> _deleteUser() async {
  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete User'),
  //       content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: const Text(
  //             'Delete',
  //             style: TextStyle(color: Colors.red),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
    
  //   if (confirm != true) {
  //     return;
  //   }
    
  //   setState(() {
  //     _isLoading = true;
  //   });
    
  //   try {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //     // Using the original method name from the error messages
  //     await authProvider.removeHouseholdMember(widget.user.id);
      
  //     if (mounted) {
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('User deleted successfully'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
      
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }


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

  if (confirm != true) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await authProvider.deleteUser(widget.user.id);

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
            onPressed: _deleteUser,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 32),
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