import 'package:flutter/material.dart';
import 'package:stockorra/services/inventory_service.dart'; // Adjust path as needed

class LowStockCard extends StatelessWidget {
  final String itemName;
  final int stockLeft;
  final InventoryService inventoryService;

  const LowStockCard({
    super.key,
    required this.itemName,
    required this.stockLeft,
    required this.inventoryService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600
                )
              ),
              const SizedBox(height: 5),
              Text(
                '$stockLeft left',
                style: const TextStyle(
                  fontSize: 14, 
                  color: Colors.red
                )
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement restock functionality
              _showRestockDialog(context);
            },
            child: const Text("Restock"),
          ),
        ],
      ),
    );
  }

  void _showRestockDialog(BuildContext context) {
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restock $itemName'),
        content: TextField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter restock quantity'
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              int? restockQuantity = int.tryParse(quantityController.text);
              if (restockQuantity != null && restockQuantity > 0) {
                // TODO: Implement actual restock logic
                Navigator.of(context).pop();
              }
            },
            child: const Text('Restock'),
          ),
        ],
      ),
    );
  }
}