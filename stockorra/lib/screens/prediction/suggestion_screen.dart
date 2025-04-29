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
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firebase Firestore instance
  final FirebaseService _firebaseService = FirebaseService(); // Firebase service to interact with the database
  late PredictionService _predictionService; // Service for generating purchase suggestions

  List<Map<String, dynamic>> _suggestions = []; // List to store purchase suggestions
  bool _isLoading = false; // Loading state flag

  @override
  void initState() {
    super.initState();
    _predictionService = PredictionService(_firebaseService); // Initialize prediction service with Firebase service
    _loadSuggestions(); // Load suggestions when the screen initializes
  }

  // Function to load purchase suggestions
  Future<void> _loadSuggestions() async {
    if (_auth.currentUser == null) {
      // Redirect to login if not authenticated
      Navigator.pushReplacementNamed(context, Routes.login);
      return;
    }

    setState(() {
      _isLoading = true; // Set loading state to true while fetching data
    });

    try {
      // Fetch purchase suggestions from prediction service
      final suggestions = await _predictionService.generatePurchaseSuggestions();
      setState(() {
        _suggestions = suggestions; // Set the fetched suggestions to the state
        _isLoading = false; // Set loading state to false once data is loaded
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading state to false if there is an error
      });
      _showErrorSnackBar('Error loading suggestions: $e'); // Show error message
    }
  }

  // Function to display an error message in a snack bar
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
        title: const Text('Purchase Suggestions'), // AppBar title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.dashboard), // Navigate to the dashboard
        ),
        actions: [
          // Refresh button to reload suggestions
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSuggestions, // Reload suggestions
          ),
        ],
      ),
      body: _buildBody(), // Call the method to build the body of the screen
    );
  }

  // Method to build the body of the screen
  Widget _buildBody() {
    if (_isLoading) {
      // Show loading indicator while fetching data
      return const Center(child: CircularProgressIndicator());
    }

    if (_suggestions.isEmpty) {
      // Display a message if no suggestions are available
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
              onPressed: _loadSuggestions, // Button to refresh suggestions
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    // Display the list of suggestions in a ListView
    return ListView.builder(
      itemCount: _suggestions.length, // Set the number of items in the list
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index]; // Get the current suggestion
        return SuggestionCardWidget(
          itemName: suggestion['itemName'], // Item name from the suggestion
          currentQuantity: suggestion['currentQuantity'], // Current quantity of the item
          suggestedQuantity: suggestion['suggestedQuantity'], // Suggested quantity to purchase
          reason: suggestion['reason'], // Reason for the suggestion
          onAccept: () => _acceptSuggestion(suggestion), // Action when the user accepts the suggestion
        );
      },
    );
  }

  // Method to accept a purchase suggestion and add it to the user's shopping list
  Future<void> _acceptSuggestion(Map<String, dynamic> suggestion) async {
    try {
      // Ensure user is authenticated
      final user = _auth.currentUser;
      if (user == null) {
        _showErrorSnackBar('Please log in to add suggestions'); // Show error if user is not logged in
        return;
      }

      // Add the accepted suggestion to the user's shopping list in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('shopping_list')
          .add({
        'itemId': suggestion['itemId'], // Item ID from the suggestion
        'itemName': suggestion['itemName'], // Item name from the suggestion
        'quantity': suggestion['suggestedQuantity'], // Suggested quantity to purchase
        'reason': suggestion['reason'], // Reason for the suggestion
        'timestamp': FieldValue.serverTimestamp(), // Timestamp of when the suggestion was added
      });

      if (mounted) {
        // Show success message when the suggestion is added to the shopping list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to shopping list'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message if there is a failure while adding the suggestion
      _showErrorSnackBar('Error adding suggestion: $e');
    }
  }
}
