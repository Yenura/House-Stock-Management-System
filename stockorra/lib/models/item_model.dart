import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final int usageFrequency; // times used per week/month
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.purchaseDate,
    this.expiryDate,
    this.usageFrequency = 0,
    this.imageUrl,
    this.metadata,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      quantity: data['quantity'] ?? 0,
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      expiryDate: data['expiryDate'] != null 
          ? (data['expiryDate'] as Timestamp).toDate() 
          : null,
      usageFrequency: data['usageFrequency'] ?? 0,
      imageUrl: data['imageUrl'],
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'purchaseDate': purchaseDate,
      'expiryDate': expiryDate,
      'usageFrequency': usageFrequency,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }

  ItemModel copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    int? usageFrequency,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      usageFrequency: usageFrequency ?? this.usageFrequency,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}