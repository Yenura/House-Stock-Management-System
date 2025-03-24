import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<Map<String, dynamic>> _shoppingItems = [
    {'name': 'Milk', 'quantity': 2, 'unit': 'L', 'isChecked': false},
    {'name': 'Bread', 'quantity': 3, 'unit': 'loaves', 'isChecked': false},
    {'name': 'Eggs', 'quantity': 1, 'unit': 'dozen', 'isChecked': false},
    {'name': 'Butter', 'quantity': 1, 'unit': 'kg', 'isChecked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView.builder(
        itemCount: _shoppingItems.length,
        itemBuilder: (context, index) {
          final item = _shoppingItems[index];
          return ListTile(
            leading: Checkbox(
              value: item['isChecked'],
              onChanged: (bool? value) {
                setState(() {
                  item['isChecked'] = value ?? false;
                });
              },
            ),
            title: Text(item['name']),
            subtitle: Text('${item['quantity']} ${item['unit']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _shoppingItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewItem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Item Name'),
              onChanged: (value) {
                // TODO: Implement item name input
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // TODO: Implement quantity input
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Unit'),
              onChanged: (value) {
                // TODO: Implement unit input
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement add item logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
