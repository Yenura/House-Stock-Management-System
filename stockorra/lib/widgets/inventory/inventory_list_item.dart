import 'package:flutter/material.dart';
import 'package:stockorra/services/inventory_service.dart';

class InventoryListItem extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final InventoryService inventoryService;

  const InventoryListItem({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.inventoryService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Category: $category\nQuantity: $quantity"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // TODO: Implement edit functionality
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) => EditInventoryItemScreen(item: this)
                // ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _confirmDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              inventoryService.deleteItem(id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
