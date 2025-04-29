import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/widgets/profile/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the AuthProvider to manage authentication-related functionality (e.g., sign out).
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // AppBar with title coming from AppStrings constants.
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account section header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // White background color for the section
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Column(
                children: [
                  // Edit Profile option
                  SettingsTile(
                    icon: Icons.person, // Person icon for profile
                    title: AppStrings.editProfile, // Title from AppStrings constants
                    onTap: () {
                      // TODO: Navigate to the edit profile screen
                    },
                  ),
                  const Divider(height: 1), // Divider between list items
                  // Security option
                  SettingsTile(
                    icon: Icons.security, 
                    title: AppStrings.security,
                    onTap: () {
                      // TODO: Navigate to the security settings screen
                    },
                  ),
                  const Divider(height: 1),
                  // Notifications option
                  SettingsTile(
                    icon: Icons.notifications,
                    title: AppStrings.notifications,
                    onTap: () {
                      // TODO: Navigate to the notifications settings screen
                    },
                  ),
                  const Divider(height: 1),
                  // Privacy option
                  SettingsTile(
                    icon: Icons.privacy_tip,
                    title: AppStrings.privacy,
                    onTap: () {
                      // TODO: Navigate to the privacy settings screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Space between sections
            // Support & About section header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Support & About',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Help and Support option
                  SettingsTile(
                    icon: Icons.help,
                    title: AppStrings.helpAndSupport,
                    onTap: () {
                      // TODO: Navigate to the help and support screen
                    },
                  ),
                  const Divider(height: 1),
                  // Terms and Policies option
                  SettingsTile(
                    icon: Icons.description,
                    title: AppStrings.termsAndPolicies,
                    onTap: () {
                      // TODO: Navigate to the terms and policies screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Space between sections
            // Actions section header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Report Problem option
                  SettingsTile(
                    icon: Icons.report_problem,
                    title: AppStrings.reportProblem,
                    onTap: () {
                      // TODO: Navigate to the report problem screen
                    },
                  ),
                  const Divider(height: 1),
                  // Logout option with confirmation dialog
                  SettingsTile(
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    onTap: () async {
                      // Showing a dialog to confirm logout action
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false), // Cancel action
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true), // Confirm action
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      // If user confirms logout, sign them out and navigate to login screen
                      if (confirmed == true) {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login', // Navigating to login screen
                            (route) => false, // Clearing the navigation stack
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
