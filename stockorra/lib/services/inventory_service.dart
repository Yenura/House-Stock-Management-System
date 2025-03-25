import '../models/inventory_item.dart';

class InventoryService {
  final List<InventoryItem> _items = [];

  List<InventoryItem> getItems() => List.from(_items);

  void addItem(InventoryItem item) {
    _items.add(item);
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void updateItem(InventoryItem updatedItem) {
    int index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
    }
  }
}
