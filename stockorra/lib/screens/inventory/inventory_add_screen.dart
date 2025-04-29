import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockorra/services/inventory_service.dart';
import 'package:stockorra/models/inventory_item.dart';

class InventoryAddScreen extends StatefulWidget {
  final InventoryService inventoryService;

  const InventoryAddScreen({
    super.key,
    required this.inventoryService,
  });

  @override
  State<InventoryAddScreen> createState() => _InventoryAddScreenState();
}

class _InventoryAddScreenState extends State<InventoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _expirationController.dispose();
    super.dispose();
  }
//..
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newItem = InventoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: _categoryController.text,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        expirationDate: _expirationController.text,
      );
      widget.inventoryService.addItem(newItem);
      Navigator.pop(context);
    }
  }

  // Function to open the calendar date picker and freeze past dates
  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Freeze past dates
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) {
        // Allow only today or future dates
        return date.isAfter(DateTime.now().subtract(const Duration(days: 1))) ||
            date.isAtSameMomentAs(DateTime.now());
      },
    );

    if (selectedDate != null) {
      setState(() {
        // Format the date in yyyy-mm-dd format
        _expirationController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Inventory Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Item Name Validation
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

              // Category Validation
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

              // Quantity Validation
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Please enter a valid quantity greater than zero';
                  }
                  return null;
                },
              ),

              // Expiration Date Validation
              GestureDetector(
                onTap: () => _selectExpirationDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _expirationController,
                    decoration: const InputDecoration(
                      labelText: 'Expiration Date',
                      hintText: 'Select expiration date',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an expiration date';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
