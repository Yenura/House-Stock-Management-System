import 'package:stockorra/models/inventory_item.dart';

class InventoryService {
  final List<InventoryItem> _inventory = [];

  void addItem(InventoryItem item) {
    _inventory.add(item);
  }

  void deleteItem(String id) {
    _inventory.removeWhere((item) => item.id == id);
  }

  void updateItem(InventoryItem updatedItem) {
    int index = _inventory.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _inventory[index] = updatedItem;
    }
  }

  List<InventoryItem> getItems() {
    return List.unmodifiable(_inventory); // Prevent direct modifications
  }
}
