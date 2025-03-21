import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpiryCardWidget extends StatelessWidget {
  final String itemName;
  final String itemCategory;
  final int quantity;
  final DateTime expiryDate;
  final int daysRemaining;

  const ExpiryCardWidget({
    Key? key,
    required this.itemName,
    required this.itemCategory,
    required this.quantity,
    required this.expiryDate,
    required this.daysRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define background color based on days remaining
    Color bgColor;
    if (daysRemaining < 0) {
      bgColor = Colors.red.shade100; // Expired
    } else if (daysRemaining < 3) {
      bgColor = Colors.orange.shade100; // About to expire
    } else if (daysRemaining < 7) {
      bgColor = Colors.yellow.shade100; // Expiring soon
    } else {
      bgColor = Colors.green.shade50; // Safe
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(itemCategory),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16),
                const SizedBox(width: 8),
                Text('Quantity: $quantity'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text('Expires: ${DateFormat('MMM dd, yyyy').format(expiryDate)}'),
              ],
            ),
            const SizedBox(height: 8),
            _buildExpiryIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryIndicator(BuildContext context) {
    String message;
    Color color;
    IconData icon;

    if (daysRemaining < 0) {
      message = 'Expired ${-daysRemaining} days ago';
      color = Colors.red;
      icon = Icons.warning_amber_rounded;
    } else if (daysRemaining == 0) {
      message = 'Expires today';
      color = Colors.red;
      icon = Icons.warning_amber_rounded;
    } else if (daysRemaining == 1) {
      message = 'Expires tomorrow';
      color = Colors.orange;
      icon = Icons.error_outline;
    } else if (daysRemaining < 7) {
      message = 'Expires in $daysRemaining days';
      color = Colors.orange;
      icon = Icons.timelapse;
    } else {
      message = 'Expires in $daysRemaining days';
      color = Colors.green;
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            message,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}