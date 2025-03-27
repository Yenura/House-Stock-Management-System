import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventory_item.dart';

class InventoryService {
  final _firestore = FirebaseFirestore.instance;
  final String collection = 'inventory';

  Stream<List<InventoryItem>> getItemsStream() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return InventoryItem(
          id: doc.id,
          name: data['name'] ?? '',
          category: data['category'] ?? '',
          quantity: data['quantity'] ?? 0,
          expirationDate: data['expirationDate'] ?? '',
        );
      }).toList();
    });
  }

  Future<Map<String, dynamic>> getInventoryReport() async {
    final snapshot = await _firestore.collection(collection).get();
    final items = snapshot.docs;

    // Calculate category summaries
    Map<String, int> categorySummary = {};
    int totalItems = 0;

    for (var doc in items) {
      final data = doc.data();
      final category = data['category'] as String? ?? 'Uncategorized';
      final quantity = (data['quantity'] as num?)?.toInt() ?? 0;

      categorySummary[category] = (categorySummary[category] ?? 0) + quantity;
      totalItems += quantity;
    }

    return {
      'items': items,
      'categorySummary': categorySummary,
      'totalItems': totalItems,
      'totalCategories': categorySummary.length,
      'generatedAt': DateTime.now(),
    };
  }

  Future<void> addItem(InventoryItem item) async {
    await _firestore.collection(collection).add({
      'name': item.name,
      'category': item.category,
      'quantity': item.quantity,
      'expirationDate': item.expirationDate,
    });
  }

  Future<void> deleteItem(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  Future<void> updateItem(String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }
}
