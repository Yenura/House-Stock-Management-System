import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/widgets/profile/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.person,
                    title: AppStrings.editProfile,
                    onTap: () {
                      // TODO: Navigate to edit profile screen
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.security,
                    title: AppStrings.security,
                    onTap: () {
                      // TODO: Navigate to security settings screen
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.notifications,
                    title: AppStrings.notifications,
                    onTap: () {
                      // TODO: Navigate to notifications settings screen
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.privacy_tip,
                    title: AppStrings.privacy,
                    onTap: () {
                      // TODO: Navigate to privacy settings screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                  SettingsTile(
                    icon: Icons.help,
                    title: AppStrings.helpAndSupport,
                    onTap: () {
                      // TODO: Navigate to help and support screen
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.description,
                    title: AppStrings.termsAndPolicies,
                    onTap: () {
                      // TODO: Navigate to terms and policies screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                  SettingsTile(
                    icon: Icons.report_problem,
                    title: AppStrings.reportProblem,
                    onTap: () {
                      // TODO: Navigate to report problem screen
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.person_add,
                    title: AppStrings.addAccount,
                    onTap: () {
                      // TODO: Navigate to add account screen
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    onTap: () async {
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
                      
                      if (confirmed == true) {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
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