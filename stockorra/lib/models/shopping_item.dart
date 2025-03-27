class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final bool purchased;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.purchased,
  });

  // Convert Firestore document to ShoppingItem
  factory ShoppingItem.fromFirestore(Map<String, dynamic> data) {
    return ShoppingItem(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      purchased: data['purchased'] ?? false,
    );
  }

  // Convert ShoppingItem to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'purchased': purchased,
    };
  }
}
