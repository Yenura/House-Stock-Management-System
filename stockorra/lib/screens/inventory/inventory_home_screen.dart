import 'package:flutter/material.dart';
import '../../../models/inventory_item.dart';
import 'inventory_add_screen.dart';

class InventoryHomeScreen extends StatefulWidget {
  const InventoryHomeScreen({super.key});

  @override
  State<InventoryHomeScreen> createState() => _InventoryHomeScreenState();
}

class _InventoryHomeScreenState extends State<InventoryHomeScreen> {
  final InventoryService _inventoryService = InventoryService();
  List<InventoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  void _loadInventory() {
    setState(() {
      _items = _inventoryService.getItems();
    });
  }

  void _navigateToAddItemScreen() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InventoryAddScreen()),
    );

    if (newItem != null && newItem is InventoryItem) {
      setState(() {
        _inventoryService.addItem(newItem);
        _items = _inventoryService.getItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body:
          _items.isEmpty
              ? const Center(
                child: Text('No items available. Add new inventory.'),
              )
              : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index].name),
                    subtitle: Text('Category: ${_items[index].category}'),
                    trailing: Text('Qty: ${_items[index].quantity}'),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItemScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
