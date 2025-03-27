import 'package:flutter/material.dart';
import '../../../models/item_model.dart';
import '../../../services/firebase_service.dart';
import '../../../services/prediction_service.dart';
import '../../../widgets/prediction/expiry_card_widget.dart';

class ExpiryPredictionScreen extends StatefulWidget {
  const ExpiryPredictionScreen({super.key});

  @override
  _ExpiryPredictionScreenState createState() => _ExpiryPredictionScreenState();
}

class _ExpiryPredictionScreenState extends State<ExpiryPredictionScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late PredictionService _predictionService;
  
  @override
  void initState() {
    super.initState();
    _predictionService = PredictionService(_firebaseService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Predictions'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: StreamBuilder<List<ItemModel>>(
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
          
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return FutureBuilder<DateTime>(
                future: _predictionService.predictExpiryDate(item),
                builder: (context, predictionSnapshot) {
                  if (predictionSnapshot.connectionState == ConnectionState.waiting) {
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
        onPressed: _generateReportDialog,
        child: const Icon(Icons.assessment),
      ),
    );
  }
  
  void _generateReportDialog() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final report = await _predictionService.generateInventoryReport();
      
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inventory Report'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Date: ${report['reportDate']}'),
                const SizedBox(height: 8),
                Text('Total Items: ${report['totalItems']}'),
                const SizedBox(height: 16),
                const Text('Category Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...(report['categoryBreakdown'] as Map<String, int>).entries.map((e) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('${e.key}: ${e.value} items'),
                  )
                ),
                const SizedBox(height: 16),
                const Text('Items Expiring Soon:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...(report['expiringItems'] as List).map((item) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('${item['name']} - ${item['expiryDate']} (${item['daysRemaining']} days)'),
                  )
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating report: $e')),
      );
    }
  }
}