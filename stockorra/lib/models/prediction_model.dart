import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionModel {
  final String id;
  final String itemId;
  final String itemName;
  final DateTime predictedExpiryDate;
  final int suggestedQuantity;
  final double confidenceScore; // 0-1 indicating prediction confidence
  final DateTime createdAt;

  PredictionModel({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.predictedExpiryDate,
    required this.suggestedQuantity,
    required this.confidenceScore,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'predictedExpiryDate': predictedExpiryDate,
      'suggestedQuantity': suggestedQuantity,
      'confidenceScore': confidenceScore,
      'createdAt': createdAt,
    };
  }

  factory PredictionModel.fromMap(Map<String, dynamic> map, String id) {
    return PredictionModel(
      id: id,
      itemId: map['itemId'],
      itemName: map['itemName'],
      predictedExpiryDate: (map['predictedExpiryDate'] as Timestamp).toDate(),
      suggestedQuantity: map['suggestedQuantity'],
      confidenceScore: map['confidenceScore'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}