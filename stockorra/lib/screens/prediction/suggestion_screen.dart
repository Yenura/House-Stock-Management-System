import 'package:flutter/material.dart';
import '../../../services/firebase_service.dart';
import '../../../services/prediction_service.dart';
import '../../../widgets/prediction/suggestion_card_widget.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
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
    setState(() {
      _isLoading = true;
    });
    
    try {
      final suggestions = await _predictionService.generatePurchaseSuggestions();
      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading suggestions: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Suggestions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSuggestions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _suggestions.isEmpty
              ? const Center(child: Text('No purchase suggestions at this time'))
              : ListView.builder(
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
                ),
    );
  }
  
  void _acceptSuggestion(Map<String, dynamic> suggestion) async {
    try {
      await _firebaseService.saveSuggestion(
        suggestion['itemId'],
        suggestion['suggestedQuantity'],
        suggestion['reason'],
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to shopping list')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}