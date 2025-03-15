import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final int quantity;
  final String category;
  final String location;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final double price;
  final String uom; // unit of measurement
  final String barcode;
  final List<UsageHistory> usageHistory;
  final bool isLowStock;
  final int minStockLevel;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.location,
    required this.purchaseDate,
    this.expiryDate,
    required this.price,
    required this.uom,
    required this.barcode,
    required this.usageHistory,
    required this.isLowStock,
    required this.minStockLevel,
  });

  // Factory constructor to create an InventoryItem from a Firestore document
  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    final List<UsageHistory> history = [];
    if (data['usageHistory'] != null) {
      for (var item in data['usageHistory']) {
        history.add(UsageHistory.fromMap(item));
      }
    }

    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      expiryDate: data['expiryDate'] != null 
          ? (data['expiryDate'] as Timestamp).toDate() 
          : null,
      price: (data['price'] ?? 0).toDouble(),
      uom: data['uom'] ?? '',
      barcode: data['barcode'] ?? '',
      usageHistory: history,
      isLowStock: data['isLowStock'] ?? false,
      minStockLevel: data['minStockLevel'] ?? 0,
    );
  }

  // Convert to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'location': location,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'price': price,
      'uom': uom,
      'barcode': barcode,
      'usageHistory': usageHistory.map((h) => h.toMap()).toList(),
      'isLowStock': isLowStock,
      'minStockLevel': minStockLevel,
    };
  }

  // Create a copy of this item with updated values
  InventoryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    String? category,
    String? location,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    double? price,
    String? uom,
    String? barcode,
    List<UsageHistory>? usageHistory,
    bool? isLowStock,
    int? minStockLevel,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      location: location ?? this.location,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      price: price ?? this.price,
      uom: uom ?? this.uom,
      barcode: barcode ?? this.barcode,
      usageHistory: usageHistory ?? this.usageHistory,
      isLowStock: isLowStock ?? this.isLowStock,
      minStockLevel: minStockLevel ?? this.minStockLevel,
    );
  }
}

class UsageHistory {
  final DateTime date;
  final int quantityUsed;
  final String notes;

  UsageHistory({
    required this.date,
    required this.quantityUsed,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'quantityUsed': quantityUsed,
      'notes': notes,
    };
  }

  factory UsageHistory.fromMap(Map<String, dynamic> map) {
    return UsageHistory(
      date: (map['date'] as Timestamp).toDate(),
      quantityUsed: map['quantityUsed'] ?? 0,
      notes: map['notes'] ?? '',
    );
  }
}