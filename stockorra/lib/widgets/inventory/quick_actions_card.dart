import 'package:flutter/material.dart';
import 'package:stockorra/screens/inventory/inventory_add_screen.dart';
import 'package:stockorra/screens/inventory/inventory_list_screen.dart';
import 'package:stockorra/services/inventory_service.dart';

class QuickActionsCard extends StatelessWidget {
  final InventoryService inventoryService;

  const QuickActionsCard({
    super.key,
    required this.inventoryService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Quick Actions"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(context, Icons.add, "Add Item",
                  () => _navigateToAddItem(context)),
              _buildActionButton(context, Icons.qr_code_scanner, "Scan",
                  () => _handleScan(context)),
              _buildActionButton(context, Icons.list, "Lists",
                  () => _navigateToInventoryList(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  void _navigateToAddItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventoryAddScreen(
          inventoryService: inventoryService,
        ),
      ),
    );
  }

  void _handleScan(BuildContext context) {
    // TODO: Implement QR/Barcode scanning logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scanning feature coming soon!')),
    );
  }

  void _navigateToInventoryList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventoryListScreen(
          inventoryService: inventoryService,
        ),
      ),
    );
  }
}
