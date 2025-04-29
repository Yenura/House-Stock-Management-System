import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
//.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inupa Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InventoryScreen(),
    );
  }
}

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OUR INVENTORY'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 16),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(Icons.qr_code_scanner, 'Scan', () {}),
                    _buildActionButton(Icons.add, 'Add', () {}),
                    _buildActionButton(Icons.upload, 'Export', () {}),
                    _buildActionButton(Icons.filter_list, 'Filter', () {}),
                    _buildActionButton(Icons.list, 'Lists', () {
                      print('Lists Clicked');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InventoryScreen()),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 16),
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
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.orange[100],
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Low Stock Alert    3 items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Low stock items
          ListTile(
            leading: Icon(Icons.local_drink, color: Colors.blue),
            title: Text('Milk'),
            trailing: Text('1 left', style: TextStyle(color: Colors.red)),
          ),
          ListTile(
            leading: Icon(Icons.bakery_dining, color: Colors.brown),
            title: Text('Bread'),
            trailing: Text('2 left', style: TextStyle(color: Colors.red)),
          ),
          Divider(),
          // Current inventory title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Current Inventory',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          // Inventory items
          _buildInventoryItem('Rice', '5kg package', 3),
          _buildInventoryItem('Detergent', '2L bottle', 2),
          Spacer(),
          // Bottom navigation
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
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
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        Icon(icon, size: 28),
        SizedBox(height: 4),
        Text(label),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String text, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Colors.blue
              : Colors.grey[300], // Changed from primary
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildInventoryItem(String name, String description, int count) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.shopping_basket, color: Colors.grey[600]),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
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
                icon: Icon(Icons.remove),
                onPressed: () {},
                iconSize: 18,
                padding: EdgeInsets.zero,
              ),
              Text(count.toString()),
              IconButton(
                icon: Icon(Icons.add),
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

class InventoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const InventoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: Text('Details for ${item['name']}'),
      ),
    );
  }
}
