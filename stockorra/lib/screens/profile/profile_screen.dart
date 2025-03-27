import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'User Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user?.email ?? 'email@example.com',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileOption(
              context,
              'Edit Profile',
              Icons.edit_outlined,
              () {
                if (user != null) {
                  Navigator.pushNamed(
                    context,
                    Routes.editUser,
                    arguments: user,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to edit profile'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            _buildProfileOption(
              context,
              'Household Members',
              Icons.people_outline,
              () => Navigator.pushNamed(context, Routes.householdList),
            ),
            _buildProfileOption(
              context,
              'Add User',
              Icons.person_add_outlined,
              () => Navigator.pushNamed(context, Routes.addUser),
            ),
            _buildProfileOption(
              context,
              'Settings',
              Icons.settings_outlined,
              () => Navigator.pushNamed(context, Routes.settings),
            ),
            _buildProfileOption(
              context,
              'Logout',
              Icons.logout,
              () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  await authProvider.signOut();
                  if (context.mounted) {
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

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
