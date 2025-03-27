import 'package:flutter/material.dart';

class ExpiryPredictionScreen extends StatelessWidget {
  const ExpiryPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Predictions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExpiryCard(
            'Soon to Expire',
            Colors.red,
            [
              'Milk - Expires in 2 days',
              'Bread - Expires in 3 days',
              'Yogurt - Expires in 4 days',
            ],
          ),
          const SizedBox(height: 16),
          _buildExpiryCard(
            'Expiring This Week',
            Colors.orange,
            [
              'Cheese - Expires in 5 days',
              'Eggs - Expires in 6 days',
              'Vegetables - Expires in 7 days',
            ],
          ),
          const SizedBox(height: 16),
          _buildExpiryCard(
            'Expiring Next Week',
            Colors.green,
            [
              'Canned Food - Expires in 8 days',
              'Juice - Expires in 10 days',
              'Fruits - Expires in 12 days',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryCard(String title, Color color, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(item),
                )),
          ],
        ),
      ),
    );
  }
}
