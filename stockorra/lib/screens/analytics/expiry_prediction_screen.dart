import 'package:flutter/material.dart';

class ExpiryPredictionScreen extends StatelessWidget {
  const ExpiryPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Prediction'),
      ),
      body: const Center(
        child: Text('Expiry Prediction Screen'),
      ),
    );
  }
}
