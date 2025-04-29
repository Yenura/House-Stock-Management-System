import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockorra/models/shopping_item.dart';

class EditShoppingListScreen extends StatefulWidget {
  final ShoppingItem item; // The shopping item to be edited, passed through the constructor

  const EditShoppingListScreen({super.key, required this.item});

  @override
  State<EditShoppingListScreen> createState() => _EditShoppingListScreenState();
}

class _EditShoppingListScreenState extends State<EditShoppingListScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  late TextEditingController _itemNameController; // Controller for the item name text field
  late TextEditingController _quantityController; // Controller for the quantity text field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance for database interaction

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current values from the passed item
    _itemNameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
  }

  // Method to update the shopping item in Firestore
  Future<void> _updateShoppingItem() async {
    if (_formKey.currentState!.validate()) { // Validate the form inputs
      try {
        // Create an updated ShoppingItem object
        final updatedItem = ShoppingItem(
          id: widget.item.id, // Preserve the original item's ID
          name: _itemNameController.text, // Get the updated name from the controller
          quantity: int.parse(_quantityController.text), // Get the updated quantity
          purchased: widget.item.purchased, // Retain the 'purchased' status
        );

        // Update the item in Firestore using the item's document ID
        await _firestore
            .collection('shopping_items')
            .doc(widget.item.id)
            .update(updatedItem.toFirestore());

        Navigator.pop(context); // Pop the screen to go back to the previous screen
      } catch (e) {
        // Show an error message if the update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating item: $e')),
        );
      }
    }
  }

  // Method to delete the shopping item from Firestore
  Future<void> _deleteShoppingItem() async {
    try {
      // Delete the item from Firestore using the item's document ID
      await _firestore.collection('shopping_items').doc(widget.item.id).delete();
      Navigator.pop(context); // Pop the screen to go back after deletion
    } catch (e) {
      // Show an error message if the deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up memory when the widget is disposed
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shopping Item'), // App bar with title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the body content
        child: Form(
          key: _formKey, // Form widget that uses the form key for validation
          child: Column(
            children: [
              // Text field for item name
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name', // Label for item name field
                ),
                validator: (value) {
                  // Validate the item name field
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null; // No error if value is valid
                },
              ),
              const SizedBox(height: 16), // Space between fields
              // Text field for quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity', // Label for quantity field
                ),
                keyboardType: TextInputType.number, // Restrict input to numbers
                validator: (value) {
                  // Validate the quantity field
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number'; // Error if input is not a valid number
                  }
                  return null; // No error if value is valid
                },
              ),
              const SizedBox(height: 24), // Space before buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                children: [
                  // Button to update the item
                  ElevatedButton(
                    onPressed: _updateShoppingItem,
                    child: const Text('Update Item'),
                  ),
                  // Button to delete the item
                  ElevatedButton(
                    onPressed: _deleteShoppingItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red color for delete button
                    ),
                    child: const Text('Delete Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
