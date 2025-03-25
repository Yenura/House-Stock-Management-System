import 'package:flutter/material.dart';

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OUR INVENTORY'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Action Buttons Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(Icons.qr_code_scanner, "Scan"),
                    _buildActionButton(Icons.add, "Add"),
                    _buildActionButton(Icons.upload, "Export"),
                    _buildActionButton(Icons.filter_list, "Filter"),
                  ],
                ),
                const SizedBox(height: 16),
                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryButton('All Items', isSelected: true),
                      _buildCategoryButton('Groceries'),
                      _buildCategoryButton('Household'),
                      _buildCategoryButton('Elec'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Low stock alert
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.orange[100],
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Low Stock Alert    3 items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Low stock items
          _buildLowStockItem('Milk', '1 left'),
          _buildLowStockItem('Bread', '2 left'),
          const Divider(),
          // Current inventory title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Current Inventory',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          // Inventory items
          Expanded(
            child: ListView(
              children: [
                _buildInventoryItem('Rice', '5kg package', 3),
                _buildInventoryItem('Detergent', '2L bottle', 2),
                // Add more items as needed
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle the button press (you can navigate or perform actions here)
        print('$label button pressed');
      },
      icon: Icon(icon, size: 28),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildLowStockItem(String name, String quantity) {
    return ListTile(
      leading: Icon(
        name == 'Milk' ? Icons.local_drink : Icons.bakery_dining,
        color: name == 'Milk' ? Colors.blue : Colors.brown,
      ),
      title: Text(name),
      trailing: Text(quantity, style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildInventoryItem(String name, String description, int count) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.shopping_basket, color: Colors.grey[600]),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {},
                iconSize: 18,
                padding: EdgeInsets.zero,
              ),
              Text(count.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
                iconSize: 18,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
