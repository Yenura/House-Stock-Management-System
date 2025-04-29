import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shopping_list_add_screen.dart';
import 'edit_shopping_list_screen.dart';
import 'package:stockorra/models/shopping_item.dart';
import 'package:stockorra/services/report_service.dart';

// Stateful widget to manage and display the shopping list
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance to interact with the database

  // Method to delete an item from the shopping list
  Future<void> _deleteItem(String itemId) async {
    try {
      await _firestore.collection('shopping_items').doc(itemId).delete(); // Delete the document from Firestore
    } catch (e) {
      // Show an error message if an exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: $e')),
      );
    }
  }

  // Method to toggle the purchase status of an item
  Future<void> _togglePurchaseStatus(ShoppingItem item) async {
    try {
      final docRef = _firestore.collection('shopping_items').doc(item.id);
      await docRef.update({
        'purchased': !item.purchased, // Toggle the 'purchased' field
      });
    } catch (e) {
      // Show an error message if an exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating item: $e')),
      );
    }
  }

  // Method to generate and save a shopping list report
  Future<void> _generateReport(List<ShoppingItem> items) async {
    try {
      final filePath = await ReportService.generateShoppingListReport(items); // Generate the report
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report saved to: $filePath'), // Show the file path where the report is saved
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      // Show an error message if an exception occurs
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent the default back button
        title: const Text('Shopping List'), // Title of the screen
        actions: [
          // Button to generate a PDF report
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              final items = _firestore
                  .collection('shopping_items')
                  .get()
                  .then((snapshot) => snapshot.docs
                      .map((doc) => ShoppingItem.fromFirestore({
                            ...doc.data(),
                            'id': doc.id,
                          }))
                      .toList())
                  .then((items) => _generateReport(items));
            },
            tooltip: 'Generate Report', // Tooltip for the button
          ),
          // Button to add a new shopping item
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingListAddScreen(), // Navigate to add item screen
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // StreamBuilder listens to changes in the shopping items collection in Firestore
        stream: _firestore.collection('shopping_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Display error message if there is one
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting for data
          }

          // Convert Firestore documents to ShoppingItem objects
          final items = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ShoppingItem.fromFirestore({
              ...data,
              'id': doc.id,
            });
          }).toList();

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No items in shopping list',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Display the shopping list items
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    item.name, // Display item name
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Quantity: ${item.quantity}', // Display item quantity
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Button to edit the shopping item
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditShoppingListScreen(item: item), // Navigate to edit item screen
                            ),
                          );
                        },
                      ),
                      // Button to delete the shopping item
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item.id), // Delete the item
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
//.