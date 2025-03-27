import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item_model.dart';
import '../models/prediction_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Collection references
  CollectionReference get _usersRef => _firestore.collection('users');
  CollectionReference _itemsRef(String userId) => _usersRef.doc(userId).collection('items');
  CollectionReference _predictionsRef(String userId) => _usersRef.doc(userId).collection('predictions');
  CollectionReference _suggestionsRef(String userId) => _usersRef.doc(userId).collection('suggestions');
  
  // Get all items for current user
  Stream<List<ItemModel>> getItems() {
    if (currentUserId == null) return Stream.value([]);
    
    return _itemsRef(currentUserId!).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel.fromFirestore(doc);
      }).toList();
    });
  }
  
  // Get items about to expire
  Stream<List<ItemModel>> getExpiringItems({int daysThreshold = 7}) {
    if (currentUserId == null) return Stream.value([]);
    
    final thresholdDate = DateTime.now().add(Duration(days: daysThreshold));
    
    return _itemsRef(currentUserId!)
        .where('expiryDate', isLessThanOrEqualTo: thresholdDate)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ItemModel.fromFirestore(doc);
          }).toList();
        });
  }
  
  // Save a prediction
  Future<void> savePrediction(PredictionModel prediction) async {
    if (currentUserId == null) return;
    
    await _predictionsRef(currentUserId!).add(prediction.toMap());
  }
  
  // Save item usage data for prediction improvements
  Future<void> recordItemUsage(String itemId, int quantity) async {
    if (currentUserId == null) return;
    
    final usageData = {
      'itemId': itemId,
      'quantity': quantity,
      'timestamp': FieldValue.serverTimestamp(),
    };
    
    await _itemsRef(currentUserId!).doc(itemId).collection('usage').add(usageData);
  }
  
  // Get usage history for an item
  Future<List<Map<String, dynamic>>> getItemUsageHistory(String itemId) async {
    if (currentUserId == null) return [];
    
    final snapshot = await _itemsRef(currentUserId!)
        .doc(itemId)
        .collection('usage')
        .orderBy('timestamp', descending: true)
        .get();
        
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
  
  // Save a purchase suggestion
  Future<void> saveSuggestion(String itemId, int suggestedQuantity, String reason) async {
    if (currentUserId == null) return;
    
    final suggestionData = {
      'itemId': itemId,
      'suggestedQuantity': suggestedQuantity,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
      'implemented': false,
    };
    
    await _suggestionsRef(currentUserId!).add(suggestionData);
  }
  
  // Get all suggestions
  Stream<List<Map<String, dynamic>>> getSuggestions() {
    if (currentUserId == null) return Stream.value([]);
    
    return _suggestionsRef(currentUserId!)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }
}