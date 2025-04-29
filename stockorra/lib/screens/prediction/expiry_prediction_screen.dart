import 'package:flutter/material.dart';
import '../../../models/item_model.dart';
import '../../../services/firebase_service.dart';
import '../../../services/prediction_service.dart';
import '../../../widgets/prediction/expiry_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ExpiryPredictionScreen is a stateful widget that displays expiry predictions for inventory items
class ExpiryPredictionScreen extends StatefulWidget {
  const ExpiryPredictionScreen({super.key});

  @override
  _ExpiryPredictionScreenState createState() => _ExpiryPredictionScreenState();
}

class _ExpiryPredictionScreenState extends State<ExpiryPredictionScreen> {
  final FirebaseService _firebaseService = FirebaseService(); // Service to interact with Firebase
  late PredictionService _predictionService; // Service for predicting expiry dates
  
  @override
  void initState() {
    super.initState();
    _predictionService = PredictionService(_firebaseService); // Initialize prediction service with Firebase service
  }

  @override
  Widget build(BuildContext context) {
    // The build method returns a Scaffold widget, which provides basic visual structure
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Predictions'), // Title for the screen
        actions: [
          // Button to refresh the page by triggering setState
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: StreamBuilder<List<ItemModel>>(
        // StreamBuilder listens to the stream of items from Firebase
        stream: _firebaseService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            // Display error message if there's an error fetching data
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final items = snapshot.data ?? [];
          
          if (items.isEmpty) {
            // Display message when no items are found in the inventory
            return const Center(child: Text('No items in inventory'));
          }
          
          // ListView to display all items in the inventory
          return ListView.builder(
            itemCount: items.length, // Number of items in the inventory
            itemBuilder: (context, index) {
              final item = items[index]; // Get the item at the current index
              return FutureBuilder<DateTime>(
                // FutureBuilder to predict the expiry date of the item
                future: _predictionService.predictExpiryDate(item),
                builder: (context, predictionSnapshot) {
                  if (predictionSnapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while waiting for prediction result
                    return const Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('Calculating...'),
                        subtitle: LinearProgressIndicator(),
                      ),
                    );
                  }
                  
                  final predictedDate = predictionSnapshot.data ?? DateTime.now().add(const Duration(days: 30));
                  final daysRemaining = predictedDate.difference(DateTime.now()).inDays;
                  
                  // Display item details with expiry prediction
                  return ExpiryCardWidget(
                    itemName: item.name,
                    itemCategory: item.category,
                    quantity: item.quantity,
                    expiryDate: predictedDate,
                    daysRemaining: daysRemaining,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateReportDialog, // Trigger report generation when pressed
        child: const Icon(Icons.assessment), // Icon for the floating action button
      ),
    );
  }
  
  // Function to generate and display an inventory report dialog
  void _generateReportDialog() async {
    // Show loading dialog while generating the report
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      // Attempt to generate the report using the prediction service
      final report = await _predictionService.generateInventoryReport();
      
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show the report in an alert dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inventory Report'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Date: ${report['reportDate']}'), // Display report date
                const SizedBox(height: 8),
                Text('Total Items: ${report['totalItems']}'), // Display total items count
                const SizedBox(height: 16),
                const Text('Category Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...(report['categoryBreakdown'] as Map<String, int>).entries.map((e) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('${e.key}: ${e.value} items'), // Display category breakdown
                  )
                ),
                const SizedBox(height: 16),
                const Text('Items Expiring Soon:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...(report['expiringItems'] as List).map((item) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('${item['name']} - ${item['expiryDate']} (${item['daysRemaining']} days)'), // Display expiring items
                  )
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      // Display error message if generating the report fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating report: $e')),
      );
    }
  }
}
//.