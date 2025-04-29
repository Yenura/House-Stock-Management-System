import 'package:flutter/material.dart';
import '../../../services/firebase_service.dart';
import '../../../models/item_model.dart';
import '../../../widgets/prediction/usage_chart_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsageAnalyticsScreen extends StatefulWidget {
  const UsageAnalyticsScreen({super.key});

  @override
  _UsageAnalyticsScreenState createState() => _UsageAnalyticsScreenState();
}

class _UsageAnalyticsScreenState extends State<UsageAnalyticsScreen> {
  final FirebaseService _firebaseService = FirebaseService(); // Firebase service instance to interact with the Firestore
  String? _selectedItemId; // Store selected item ID for analytics
  List<Map<String, dynamic>> _usageData = []; // Store usage data for the selected item
  bool _isLoading = false; // Flag for loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usage Analytics')), // AppBar with title
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16), // Padding for the dropdown card
            child: Card(
              elevation: 3, // Elevation for card effect
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners for card
              child: Padding(
                padding: const EdgeInsets.all(16), // Padding inside the card
                child: StreamBuilder<List<ItemModel>>(
                  // StreamBuilder to fetch the list of items from Firestore
                  stream: _firebaseService.getItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator()); // Show loader while fetching data
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}')); // Show error message if fetching fails
                    }

                    final items = snapshot.data ?? []; // Retrieve items from snapshot
                    if (items.isEmpty) {
                      return const Center(child: Text('No items in inventory')); // Show message if no items available
                    }

                    return DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Item for Analysis', // Label for the dropdown
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Border style for the dropdown
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Padding for dropdown content
                        ),
                        value: _selectedItemId, // Current selected item ID
                        items: items.map((item) {
                          return DropdownMenuItem<String>( // Populate dropdown items with item names
                            value: item.id,
                            child: Text(item.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (_selectedItemId != value) {
                            setState(() {
                              _selectedItemId = value; // Update selected item ID
                              _usageData = []; // Reset usage data for new selection
                            });
                            if (value != null) {
                              _loadUsageData(value); // Load usage data for selected item
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _selectedItemId == null
                ? const Center(child: Text('Select an item to view usage analytics')) // Prompt to select an item
                : FutureBuilder<List<Map<String, dynamic>>>( // FutureBuilder to load the usage data for the selected item
                    future: _firebaseService.getItemUsageHistory(_selectedItemId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator()); // Show loader while fetching data
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}')); // Show error if data fetching fails
                      }

                      final usageData = snapshot.data ?? []; // Retrieve usage data from snapshot
                      if (usageData.isEmpty) {
                        return const Center(child: Text('No usage data available for this item')); // Show message if no data available
                      }

                      return UsageChartWidget(usageData: usageData); // Display the usage data in a chart
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Method to load usage data for the selected item
  Future<void> _loadUsageData(String itemId) async {
    setState(() {
      _isLoading = true; // Set loading state to true while fetching data
    });

    try {
      final usageHistory = await _firebaseService.getItemUsageHistory(itemId); // Fetch usage history for the selected item
      setState(() {
        _usageData = usageHistory; // Set the fetched usage data to the state
      });
    } catch (e) {
      if (mounted) {
        // Display error message if fetching usage data fails
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading usage data: $e')),
          );
        });
      }
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false after data is loaded
      });
    }
  }
}
//.