import 'package:flutter/material.dart';

class UsageReportsScreen extends StatelessWidget {
  const UsageReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usage Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportSection(
              'Inventory Usage',
              [
                'Total Items: 150',
                'Items Added This Month: 45',
                'Items Removed: 30',
                'Current Stock Value: \$2,500',
              ],
            ),
            const SizedBox(height: 24),
            _buildReportSection(
              'Category Analysis',
              [
                'Most Used Category: Groceries',
                'Least Used Category: Electronics',
                'Fastest Moving Items: Dairy Products',
                'Slowest Moving Items: Household Items',
              ],
            ),
            const SizedBox(height: 24),
            _buildReportSection(
              'Expiry Statistics',
              [
                'Items Expired This Month: 5',
                'Items Near Expiry: 12',
                'Average Shelf Life: 45 days',
                'Waste Prevention Rate: 92%',
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement report download
                },
                child: const Text('Download Full Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportSection(String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
