import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockorra/models/shopping_item.dart';

// Stateful widget to handle adding a shopping item
class ShoppingListAddScreen extends StatefulWidget {
  const ShoppingListAddScreen({super.key});

  @override
  State<ShoppingListAddScreen> createState() => _ShoppingListAddScreenState();
}

class _ShoppingListAddScreenState extends State<ShoppingListAddScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form state to handle validation
  final _itemNameController = TextEditingController(); // Controller to manage input for item name
  final _quantityController = TextEditingController(); // Controller to manage input for quantity
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance to interact with the database

  // Method to add a new shopping item to the Firestore database
  Future<void> _addShoppingItem() async {
    if (_formKey.currentState!.validate()) { // Validate the form inputs
      try {
        // Create a document reference to get the ID for the new item
        final docRef = _firestore.collection('shopping_items').doc();

        // Create a new ShoppingItem object with the data from the form
        final newItem = ShoppingItem(
          id: docRef.id, // Use the generated document ID as the item ID
          name: _itemNameController.text, // Get the item name from the controller
          quantity: int.parse(_quantityController.text), // Parse quantity as an integer
          purchased: false, // Default the purchased status to false
        );

        // Add the new item to Firestore
        await docRef.set(newItem.toFirestore());

        // Return to the previous screen after successfully adding the item
        Navigator.pop(context);
      } catch (e) {
        // Show an error message if an exception occurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding item: $e')),
        );
      }
    }
  }

  // Dispose the controllers when the widget is disposed to avoid memory leaks
  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shopping Item'), // Title of the screen
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the form
        child: Form(
          key: _formKey, // Attach the form key for validation
          child: Column(
            children: [
              // Input field for item name
              TextFormField(
                controller: _itemNameController, // Attach the controller to manage input
                decoration: const InputDecoration(
                  labelText: 'Item Name', // Label for the item name field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name'; // Validation for empty input
                  }
                  return null; // Return null if input is valid
                },
              ),
              const SizedBox(height: 16), // Space between the fields
              
              // Input field for quantity
              TextFormField(
                controller: _quantityController, // Attach the controller for quantity input
                decoration: const InputDecoration(
                  labelText: 'Quantity', // Label for the quantity field
                ),
                keyboardType: TextInputType.number, // Ensure the keyboard shows numeric input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity'; // Validation for empty input
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number'; // Validation for invalid number
                  }
                  return null; // Return null if input is valid
                },
              ),
              const SizedBox(height: 24), // Space before the submit button
              
              // Button to submit the form and add the item to the shopping list
              ElevatedButton(
                onPressed: _addShoppingItem, // Call the method to add the item
                child: const Text('Add Item'), // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//.