import 'package:flutter/material.dart';
import 'package:stockorra/services/inventory_service.dart';

class EditInventoryScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> initialData;
  final InventoryService inventoryService;

  const EditInventoryScreen({
    super.key,
    required this.docId,
    required this.initialData,
    required this.inventoryService,
  });

  @override
  State<EditInventoryScreen> createState() => _EditInventoryScreenState();
}

class _EditInventoryScreenState extends State<EditInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _quantityController;
  late TextEditingController _expirationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _categoryController =
        TextEditingController(text: widget.initialData['category']);
    _quantityController =
        TextEditingController(text: widget.initialData['quantity'].toString());
    _expirationController =
        TextEditingController(text: widget.initialData['expiration'] ?? '');
  }
//.
  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _expirationController.dispose();
    super.dispose();
  }

  Future<void> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.inventoryService.updateItem(
          widget.docId,
          {
            'name': _nameController.text,
            'category': _categoryController.text,
            'quantity': int.parse(_quantityController.text),
            'expiration': _expirationController.text,
          },
        );
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expirationController,
                decoration: const InputDecoration(labelText: 'Expiration Date'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _expirationController.text =
                        date.toIso8601String().split('T')[0];
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateItem,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Update Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
