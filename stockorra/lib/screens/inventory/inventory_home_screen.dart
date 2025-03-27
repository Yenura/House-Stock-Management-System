import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockorra/services/inventory_service.dart';
import 'inventory_add_screen.dart';
import 'inventory_list_screen.dart';

class InventoryHomeScreen extends StatelessWidget {
  final InventoryService inventoryService;

  const InventoryHomeScreen({
    super.key,
    required this.inventoryService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(216, 223, 255, 206),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Our Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('inventory')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildSummaryCard(
                            Icons.inventory, "Total Items", "...");
                      }

                      if (snapshot.hasError) {
                        return _buildSummaryCard(
                            Icons.inventory, "Total Items", "Error");
                      }

                      final totalItems = snapshot.data?.docs.length ?? 0;
                      return _buildSummaryCard(Icons.inventory, "Total Items",
                          totalItems.toString());
                    },
                  ),
                  _buildSummaryCard(Icons.warning, "Low Stock", "12"),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Actions Section with Background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Quick Actions"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(context, Icons.add, "Add Item", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InventoryAddScreen(
                                    inventoryService: inventoryService)),
                          );
                        }),
                        _buildActionButton(
                            context, Icons.qr_code_scanner, "Scan", () {
                          print("Scan Clicked");
                        }),
                        _buildActionButton(context, Icons.list, "Lists", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InventoryListScreen(
                                    inventoryService: inventoryService)),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("Categories"),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildCategoryCard(
                      Icons.local_grocery_store, "Groceries", "86 items"),
                  _buildCategoryCard(
                      Icons.cleaning_services, "Household", "52 items"),
                  _buildCategoryCard(Icons.kitchen, "Pantry", "64 items"),
                  _buildCategoryCard(Icons.bathtub, "Bathroom", "45 items"),
                ],
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("Low Stock Alert"),
              _buildLowStockItem("Water Bottles", "2 left"),
              _buildLowStockItem("Toilet Paper", "3 left"),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventoryListScreen(
                            inventoryService: inventoryService),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D7D4D),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'View All Inventory',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String count) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(count,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, String count) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(count,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildLowStockItem(String itemName, String stockLeft) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(itemName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              Text(stockLeft,
                  style: const TextStyle(fontSize: 14, color: Colors.red)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              print("Restock $itemName Clicked");
            },
            child: const Text("Restock"),
          ),
        ],
      ),
    );
  }
}
