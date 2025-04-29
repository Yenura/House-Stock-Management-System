import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/models/user_model.dart';  // Import the User model
import 'package:stockorra/providers/auth_provider.dart';  // Import the auth provider
import 'package:stockorra/screens/profile/edit_user_screen.dart';  // Import the screen for editing user
import 'package:stockorra/screens/profile/add_user_screen.dart';  // Import the screen for adding a new user
import 'package:stockorra/services/report_service.dart';  // Import the service for generating reports

class HouseholdListScreen extends StatelessWidget {
  const HouseholdListScreen({super.key});  // Constructor for the screen

  // Function to generate a household report
  Future<void> _generateReport(BuildContext context, List<User> members) async {
    try {
      final filePath = await ReportService.generateHouseholdReport(members);  // Generate the report using the ReportService
      if (context.mounted) {
        // Show a snackbar with the file path where the report is saved
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report saved to: $filePath'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Show a snackbar if there is an error generating the report
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Members'),  // Set the title of the app bar
        actions: [
          // Button to generate report
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);  // Get the AuthProvider instance
              final members = await authProvider.getHouseholdMembers();  // Fetch the household members
              if (context.mounted) {
                await _generateReport(context, members);  // Generate the report
              }
            },
            tooltip: 'Generate Report',  // Tooltip to show when hovered
          ),
          // Button to add a new user
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUserScreen()),  // Navigate to AddUserScreen to add a new member
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(  // Consumer widget to listen to AuthProvider updates
        builder: (context, authProvider, child) {
          return FutureBuilder<List<User>>(
            future: authProvider.getHouseholdMembers(),  // Fetch the list of household members
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());  // Show loading indicator while waiting
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));  // Show error if there is an issue fetching members
              }

              final members = snapshot.data ?? [];  // Get the household members from the snapshot

              if (members.isEmpty) {
                return const Center(
                  child: Text('No household members found'),  // Show message if no members found
                );
              }

              // Display list of household members
              return ListView.builder(
                itemCount: members.length,  // Set the number of items in the list
                itemBuilder: (context, index) {
                  final member = members[index];  // Get individual member
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        member.name[0].toUpperCase(),  // Display the first letter of the member's name
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(member.name),  // Display member's name
                    subtitle: Text(member.email),  // Display member's email
                    trailing: PopupMenuButton<String>(  // Popup menu for editing or deleting user
                      onSelected: (value) async {
                        switch (value) {
                          case 'edit':  // If 'edit' is selected, navigate to EditUserScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditUserScreen(user: member),  // Pass the member to the edit screen
                              ),
                            );
                            break;
                          case 'delete':  // If 'delete' is selected, show confirmation dialog
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Member'),
                                content: Text(
                                    'Are you sure you want to delete ${member.name}?'),  // Show member's name in the prompt
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),  // Cancel action
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),  // Confirm action
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),  // Red text for delete
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final success =
                                  await authProvider.deleteUser(member.id);  // Delete the user from database
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Member deleted successfully'),  // Show success message after deleting
                                  ),
                                );
                              }
                            }
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),  // Edit icon
                              SizedBox(width: 8),
                              Text('Edit'),  // Text for Edit option
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),  // Delete icon
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),  // Text for Delete option
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
//.