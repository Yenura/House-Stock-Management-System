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
  final FirebaseService _firebaseService = FirebaseService();
  String? _selectedItemId;
  List<Map<String, dynamic>> _usageData = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usage Analytics')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<List<ItemModel>>(
                  stream: _firebaseService.getItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return const Center(child: Text('No items in inventory'));
                    }

                    return DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Item for Analysis',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        value: _selectedItemId,
                        items: items.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.id,
                            child: Text(item.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (_selectedItemId != value) {
                            setState(() {
                              _selectedItemId = value;
                              _usageData = []; // Reset previous data
                            });
                            if (value != null) {
                              _loadUsageData(value);
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
                ? const Center(child: Text('Select an item to view usage analytics'))
                : FutureBuilder<List<Map<String, dynamic>>>(
                    future: _firebaseService.getItemUsageHistory(_selectedItemId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final usageData = snapshot.data ?? [];
                      if (usageData.isEmpty) {
                        return const Center(child: Text('No usage data available for this item'));
                      }

                      return UsageChartWidget(usageData: usageData);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadUsageData(String itemId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final usageHistory = await _firebaseService.getItemUsageHistory(itemId);
      setState(() {
        _usageData = usageHistory;
      });
    } catch (e) {
      if (mounted) {
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading usage data: $e')),
          );
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
