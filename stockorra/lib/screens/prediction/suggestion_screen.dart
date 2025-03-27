import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockorra/services/firebase_service.dart';
import 'package:stockorra/services/prediction_service.dart';
import 'package:stockorra/widgets/prediction/suggestion_card_widget.dart';
import 'package:stockorra/utils/routes.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();
  late PredictionService _predictionService;

  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _predictionService = PredictionService(_firebaseService);
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    if (_auth.currentUser == null) {
      // Redirect to login if not authenticated
      Navigator.pushReplacementNamed(context, Routes.login);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions =
          await _predictionService.generatePurchaseSuggestions();
      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading suggestions: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Suggestions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.dashboard),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSuggestions,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No purchase suggestions at this time',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadSuggestions,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return SuggestionCardWidget(
          itemName: suggestion['itemName'],
          currentQuantity: suggestion['currentQuantity'],
          suggestedQuantity: suggestion['suggestedQuantity'],
          reason: suggestion['reason'],
          onAccept: () => _acceptSuggestion(suggestion),
        );
      },
    );
  }

  Future<void> _acceptSuggestion(Map<String, dynamic> suggestion) async {
    try {
      // Ensure user is authenticated
      final user = _auth.currentUser;
      if (user == null) {
        _showErrorSnackBar('Please log in to add suggestions');
        return;
      }

      // Add to user's shopping list in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('shopping_list')
          .add({
        'itemId': suggestion['itemId'],
        'itemName': suggestion['itemName'],
        'quantity': suggestion['suggestedQuantity'],
        'reason': suggestion['reason'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to shopping list'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error adding suggestion: $e');
    }
  }
}
