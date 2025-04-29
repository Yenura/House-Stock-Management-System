import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/providers/auth_provider.dart';  // Importing auth provider
import 'package:stockorra/routes.dart';  // Importing routes for navigation

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});  // Constructor for ProfileScreen

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);  // Access AuthProvider
    final user = authProvider.currentUser;  // Get the current logged-in user

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,  // Disable the default back button
        title: const Text('Profile'),  // Set the title of the app bar
        actions: [
          // Settings button to navigate to the settings screen
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),  // Navigate to settings route
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),  // Add padding around the content
        child: Column(
          children: [
            // Display user profile picture (circle avatar)
            const CircleAvatar(
              radius: 50,  // Set radius for the avatar
              backgroundColor: Colors.grey,  // Background color for the avatar
              child: Icon(Icons.person, size: 50, color: Colors.white),  // Default icon if user has no profile picture
            ),
            const SizedBox(height: 16),  // Space between avatar and text
            Text(
              user?.name ?? 'User Name',  // Display user's name or placeholder if not logged in
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,  // Bold style for the name
              ),
            ),
            Text(
              user?.email ?? 'email@example.com',  // Display user's email or placeholder if not logged in
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,  // Grey color for email text
              ),
            ),
            const SizedBox(height: 32),  // Space between email and options list
            // Profile options
            _buildProfileOption(
              context,
              'Edit Profile',  // Option title
              Icons.edit_outlined,  // Edit icon
              () {
                if (user != null) {
                  // Navigate to the edit profile screen, passing the user as an argument
                  Navigator.pushNamed(
                    context,
                    Routes.editUser,
                    arguments: user,
                  );
                } else {
                  // Show a snack bar if the user is not logged in
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to edit profile'),
                      backgroundColor: Colors.red,  // Red background for the snack bar
                    ),
                  );
                }
              },
            ),
            // Option to view household members
            _buildProfileOption(
              context,
              'Household Members',
              Icons.people_outline,
              () => Navigator.pushNamed(context, Routes.householdList),
            ),
            // Option to add a new user
            _buildProfileOption(
              context,
              'Add User',
              Icons.person_add_outlined,
              () => Navigator.pushNamed(context, Routes.addUser),
            ),
            // Option to go to settings
            _buildProfileOption(
              context,
              'Settings',
              Icons.settings_outlined,
              () => Navigator.pushNamed(context, Routes.settings),
            ),
            // Option to log out
            _buildProfileOption(
              context,
              'Logout',
              Icons.logout,
              () async {
                // Show a confirmation dialog before logging out
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),  // Confirmation message
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),  // Cancel action
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),  // Confirm logout
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  // If the user confirmed, sign them out
                  await authProvider.signOut();
                  if (context.mounted) {
                    // Navigate to login screen and remove all previous routes
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the profile options in the list
  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,  // Callback function when an option is tapped
  ) {
    return ListTile(
      leading: Icon(icon),  // Display the icon for the option
      title: Text(title),  // Display the title of the option
      trailing: const Icon(Icons.chevron_right),  // Arrow icon to indicate more options
      onTap: onTap,  // Trigger the callback when the option is tapped
    );
  }
}
