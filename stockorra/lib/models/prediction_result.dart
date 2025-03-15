class PredictionResult {
  final DateTime predictedExpiryDate;
  final double confidence;
  final int suggestedStockLevel;
  final double predictedUsageRate;
  final DateTime suggestedPurchaseDate;
  
  PredictionResult({
    required this.predictedExpiryDate,
    required this.confidence,
    required this.suggestedStockLevel,
    required this.predictedUsageRate,
    required this.suggestedPurchaseDate,
  });
  
  // Create a copy with updated values
  PredictionResult copyWith({
    DateTime? predictedExpiryDate,
    double? confidence,
    int? suggestedStockLevel,
    double? predictedUsageRate,
    DateTime? suggestedPurchaseDate,
  }) {
    return PredictionResult(
      predictedExpiryDate: predictedExpiryDate ?? this.predictedExpiryDate,
      confidence: confidence ?? this.confidence,
      suggestedStockLevel: suggestedStockLevel ?? this.suggestedStockLevel,
      predictedUsageRate: predictedUsageRate ?? this.predictedUsageRate,
      suggestedPurchaseDate: suggestedPurchaseDate ?? this.suggestedPurchaseDate,
    );
  }
}