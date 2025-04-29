import 'package:flutter/material.dart';

// A reusable card widget for the dashboard grid (Inventory, Shopping, etc.)
class DashboardCard extends StatelessWidget {
  final String title; // Main title (e.g., Inventory)
  final String subtitle; // Supporting text (e.g., Manage your items)
  final IconData iconData; // Icon displayed in the card
  final Color color; // Theme color for icon background
  final VoidCallback onTap; // Action to perform when tapped

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle card tap interaction
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Subtle shadow
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container with light background tint
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                iconData,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 15),
            // Title text
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Subtitle text
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
