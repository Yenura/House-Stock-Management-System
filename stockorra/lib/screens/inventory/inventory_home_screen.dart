import 'package:flutter/material.dart';

class InventoryHomeScreen extends StatelessWidget {
  const InventoryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
              print("Settings Clicked");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inventory Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard(Icons.inventory, "Total Items", "247"),
                  _buildSummaryCard(Icons.warning, "Low Stock", "12"),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Actions
              _buildSectionTitle("Quick Actions"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(context, Icons.add, "Add Item", () {
                    // TODO: Implement Add Item Action
                    print("Add Item Clicked");
                  }),
                  _buildActionButton(context, Icons.qr_code_scanner, "Scan",
                      () {
                    // TODO: Implement Scan Action
                    print("Scan Clicked");
                  }),
                  _buildActionButton(context, Icons.list, "Lists", () {
                    // TODO: Implement Lists Action
                    print("Lists Clicked");
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Categories
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

              // Low Stock Alert
              _buildSectionTitle("Low Stock Alert"),
              _buildLowStockItem("Water Bottles", "2 left"),
              _buildLowStockItem("Toilet Paper", "3 left"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Analytics"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Summary Cards
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

  // Action Buttons
  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
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

  // Category Cards
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


      ),
    );
  }
}
