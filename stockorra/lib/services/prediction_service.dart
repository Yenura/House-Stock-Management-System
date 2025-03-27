import 'package:intl/intl.dart';
import '../models/item_model.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionService {
  final FirebaseService _firebaseService;
  
  PredictionService(this._firebaseService);
  
  // Predict expiry date based on purchase date and item type
  Future<DateTime> predictExpiryDate(ItemModel item) async {
    // For items that already have an expiry date, return it
    if (item.expiryDate != null) {
      return item.expiryDate!;
    }
    
    // Get historical data for this type of item
    final usageHistory = await _firebaseService.getItemUsageHistory(item.id);
    
    // Default shelf lives by category (in days) if no historical data
    final defaultShelfLives = {
      'dairy': 7,
      'meat': 5,
      'vegetables': 10,
      'fruits': 10,
      'canned': 365,
      'frozen': 180,
      'baked': 5,
      'cereals': 180,
      'snacks': 60,
      'beverages': 14,
      'condiments': 180,
    };
    
    // If we have usage history, calculate average shelf life
    if (usageHistory.isNotEmpty) {
      // Calculate average time between purchase and usage
      // This is simplified - a real algorithm would be more complex
      int totalDays = 0;
      int entries = 0;
      
      DateTime? lastUsage;
      for (var usage in usageHistory) {
        final timestamp = usage['timestamp'] as Timestamp;
        final usageDate = timestamp.toDate();
        
        if (lastUsage != null) {
          totalDays += usageDate.difference(lastUsage).inDays;
          entries++;
        }
        
        lastUsage = usageDate;
      }
      
      // Calculate average days between usage
      final averageDays = entries > 0 ? totalDays / entries : defaultShelfLives[item.category.toLowerCase()] ?? 30;
      
      // Add that to purchase date to get predicted expiry
      return item.purchaseDate.add(Duration(days: averageDays.round()));
    }
    
    // If no history, use default shelf life based on category
    final shelfLifeDays = defaultShelfLives[item.category.toLowerCase()] ?? 30;
    return item.purchaseDate.add(Duration(days: shelfLifeDays));
  }
  
  // Suggest purchase quantity based on usage patterns
  Future<int> suggestPurchaseQuantity(String itemId, String itemCategory) async {
    // Get usage history
    final usageHistory = await _firebaseService.getItemUsageHistory(itemId);
    
    // Default suggestions by category if no history
    final defaultSuggestions = {
      'dairy': 2,
      'meat': 1,
      'vegetables': 4,
      'fruits': 5,
      'canned': 3,
      'frozen': 2,
      'baked': 1,
      'cereals': 1,
      'snacks': 2,
      'beverages': 3,
      'condiments': 1,
    };
    
    // If we have history, calculate average usage per week
    if (usageHistory.isNotEmpty) {
      int totalQuantity = 0;
      
      for (var usage in usageHistory) {
        totalQuantity += usage['quantity'] as int;
      }
      
      // Get date range of history
      final firstUsage = (usageHistory.last['timestamp'] as Timestamp).toDate();
      final lastUsage = (usageHistory.first['timestamp'] as Timestamp).toDate();
      
      // Calculate weeks between first and last usage
      final weeks = lastUsage.difference(firstUsage).inDays / 7;
      
      // Calculate weekly usage
      if (weeks > 0) {
        final weeklyUsage = totalQuantity / weeks;
        // Suggest quantity for two weeks
        return (weeklyUsage * 2).ceil();
      }
    }
    
    // Default suggestion if no history or calculation issues
    return defaultSuggestions[itemCategory.toLowerCase()] ?? 1;
  }
  
  // Generate purchase suggestions based on inventory levels
  Future<List<Map<String, dynamic>>> generatePurchaseSuggestions() async {
    // Get current inventory
    final inventorySnapshot = await _firebaseService.getItems().first;
    final suggestions = <Map<String, dynamic>>[];
    
    for (var item in inventorySnapshot) {
      // Determine if item needs to be purchased
      if (item.quantity <= 1) { // Low quantity threshold
        // Calculate suggested quantity
        final suggestedQuantity = await suggestPurchaseQuantity(item.id, item.category);
        
        suggestions.add({
          'itemId': item.id,
          'itemName': item.name,
          'currentQuantity': item.quantity,
          'suggestedQuantity': suggestedQuantity,
          'reason': 'Low inventory',
        });
      }
      
      // Check expiry dates
      if (item.expiryDate != null) {
        final daysUntilExpiry = item.expiryDate!.difference(DateTime.now()).inDays;
        
        if (daysUntilExpiry <= 3 && daysUntilExpiry >= 0) {
          // Get suggested quantity
          final suggestedQuantity = await suggestPurchaseQuantity(item.id, item.category);
          
          suggestions.add({
            'itemId': item.id,
            'itemName': item.name,
            'currentQuantity': item.quantity,
            'suggestedQuantity': suggestedQuantity,
            'reason': 'Current stock expiring soon',
          });
        }
      }
    }
    
    return suggestions;
  }
  
  // Generate reports on inventory status
  Future<Map<String, dynamic>> generateInventoryReport() async {
    final inventory = await _firebaseService.getItems().first;
    
    // Count items by category
    final categories = <String, int>{};
    final expiringItems = <ItemModel>[];
    int totalItems = 0;
    double totalValue = 0; // If you track item value
    
    for (var item in inventory) {
      // Count by category
      if (categories.containsKey(item.category)) {
        categories[item.category] = categories[item.category]! + item.quantity;
      } else {
        categories[item.category] = item.quantity;
      }
      
      // Track expiring items
      if (item.expiryDate != null) {
        final daysUntilExpiry = item.expiryDate!.difference(DateTime.now()).inDays;
        if (daysUntilExpiry <= 7 && daysUntilExpiry >= 0) {
          expiringItems.add(item);
        }
      }
      
      // Track totals
      totalItems += item.quantity;
      
      // Track value (if available)
      final value = item.metadata?['value'] as double? ?? 0;
      totalValue += value * item.quantity;
    }
    
    // Create report
    return {
      'totalItems': totalItems,
      'totalValue': totalValue,
      'categoryBreakdown': categories,
      'expiringItems': expiringItems.map((item) => {
        'id': item.id,
        'name': item.name,
        'expiryDate': DateFormat('MMM dd, yyyy').format(item.expiryDate!),
        'daysRemaining': item.expiryDate!.difference(DateTime.now()).inDays,
      }).toList(),
      'reportDate': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
    };
  }
}