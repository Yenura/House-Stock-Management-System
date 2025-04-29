import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/models/user_model.dart'; // User model definition
import 'package:stockorra/providers/auth_provider.dart'; // Auth provider for user state
import 'package:stockorra/screens/profile/add_user_screen.dart'; // Screen to add new household member
import 'package:stockorra/screens/profile/edit_user_screen.dart'; // Screen to edit existing household member
import 'package:stockorra/screens/profile/settings_screen.dart'; // Settings page
import 'package:stockorra/utils/constants.dart'; // App-wide constants like strings and colors

// Profile screen for viewing current user info and managing household members
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Access auth state

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile), // Title from constants
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        actions: [
          // Navigate to settings screen
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Display user's first initial
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                authProvider.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Display user's name and email
            Text(
              authProvider.currentUser?.name ?? 'User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              authProvider.currentUser?.email ?? 'email@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            // Section header and Add User button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Household Members',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to AddUserScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddUserScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Fetch and display list of household users
            FutureBuilder<List<User>>(
              future: authProvider.getHouseholdMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show loading
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'), // Show error
                  );
                }

                final users = snapshot.data ?? [];

                if (users.isEmpty) {
                  return const Center(
                    child: Text('No household members found'),
                  );
                }

                // Display each user with edit option
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Prevent nested scroll
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to EditUserScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserScreen(user: user),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
