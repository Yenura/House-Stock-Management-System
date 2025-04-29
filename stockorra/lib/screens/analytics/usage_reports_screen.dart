import 'package:flutter/material.dart';

class UsageReportsScreen extends StatelessWidget {
  const UsageReportsScreen({super.key});
//.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usage Reports'),
      ),
      body: const Center(
        child: Text('Usage Reports Screen'),
      ),
    );
  }
}
