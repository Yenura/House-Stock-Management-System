import 'package:cloud_firestore/cloud_firestore.dart';

class UsageData {
  final String itemId;
  final List<UsagePoint> usagePoints;
  final double averageUsageRate;
  final double usageTrend;  // Positive means increasing usage, negative decreasing
  
  UsageData({
    required this.itemId,
    required this.usagePoints,
    required this.averageUsageRate,
    required this.usageTrend,
  });
  
  // Factory constructor from Firestore
  factory UsageData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<UsagePoint> points = [];
    
    if (data['usagePoints'] != null) {
      for (var point in data['usagePoints']) {
        points.add(UsagePoint.fromMap(point));
      }
    }
    
    return UsageData(
      itemId: doc.id,
      usagePoints: points,
      averageUsageRate: (data['averageUsageRate'] ?? 0).toDouble(),
      usageTrend: (data['usageTrend'] ?? 0).toDouble(),
    );
  }
  
  // Convert to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'usagePoints': usagePoints.map((p) => p.toMap()).toList(),
      'averageUsageRate': averageUsageRate,
      'usageTrend': usageTrend,
    };
  }
}

class UsagePoint {
  final DateTime date;
  final int quantity;
  
  UsagePoint({
    required this.date,
    required this.quantity,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'quantity': quantity,
    };
  }
  
  factory UsagePoint.fromMap(Map<String, dynamic> map) {
    return UsagePoint(
      date: (map['date'] as Timestamp).toDate(),
      quantity: map['quantity'] ?? 0,
    );
  }
}