import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dashboard_card.dart';

// Dashboard screen for the STOCKORRA app
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // Tracks the selected index for BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // App logo
            Image.asset(
              'assets/images/stockorra_logo.png',
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'STOCKORRA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      drawer: _buildDrawer(), // Navigation drawer
      body: _buildBody(), // Main body of the screen
      bottomNavigationBar: _buildBottomNavigationBar(), // Bottom nav bar
    );
  }

  // Main scrollable body content
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildStatsSection(),
          _buildFeatureSection(),
          _buildRecentActivitySection(),
        ],
      ),
    );
  }

  // Header section with greeting and search bar
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back,',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'User',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Search and QR scanner box
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search items...',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Statistics summary section
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Items',
                  value: '53',
                  iconData: Icons.inventory_2_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  title: 'Low Stock',
                  value: '7',
                  iconData: Icons.warning_amber_outlined,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Expiring Soon',
                  value: '5',
                  iconData: Icons.access_time,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  title: 'To Buy',
                  value: '12',
                  iconData: Icons.shopping_cart_outlined,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget to create a statistic card
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData iconData,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Icon(
                iconData,
                color: color,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  // Feature grid section
  Widget _buildFeatureSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 15),
          // Grid of Dashboard Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              DashboardCard(
                title: 'Inventory',
                subtitle: 'Track your items',
                iconData: Icons.inventory_2,
                color: Colors.blue,
                onTap: () {
                  // Navigate to Inventory screen
                },
              ),
              DashboardCard(
                title: 'Shopping List',
                subtitle: 'Things to buy',
                iconData: Icons.shopping_cart,
                color: Colors.green,
                onTap: () {
                  // Navigate to Shopping List screen
                },
              ),
              DashboardCard(
                title: 'Suggestions',
                subtitle: 'AI-powered insights',
                iconData: Icons.lightbulb_outline,
                color: Colors.amber,
                onTap: () {
                  // Navigate to Suggestions screen.
                },
              ),
              DashboardCard(
                title: 'Profile',
                subtitle: 'Manage settings',
                iconData: Icons.person_outline,
                color: Colors.purple,
                onTap: () {
                  // Navigate to Profile screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section for recent user activities
  Widget _buildRecentActivitySection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 15),
          // Activity list
          _buildActivityItem(
            title: 'Milk added to inventory',
            time: '2 hours ago',
            iconData: Icons.add_circle_outline,
            color: Colors.green,
          ),
          _buildActivityItem(
            title: 'Eggs running low',
            time: '5 hours ago',
            iconData: Icons.warning_amber_outlined,
            color: Colors.orange,
          ),
          _buildActivityItem(
            title: 'Bread added to shopping list',
            time: 'Yesterday',
            iconData: Icons.shopping_cart_outlined,
            color: Colors.blue,
          ),
          _buildActivityItem(
            title: 'Yogurt expiring soon',
            time: 'Yesterday',
            iconData: Icons.access_time,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  // Widget to show one activity item
  Widget _buildActivityItem({
    required String title,
    required String time,
    required IconData iconData,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              iconData,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          // Title and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16,
          ),
        ],
      ),
    );
  }

  // Navigation drawer with options
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logos
                Row(
                  children: [
                    Image.asset(
                      'assets/images/stockorra_logo.png',
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/house_icon.png',
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'user@email.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Drawer menu items
          _buildDrawerItem(
            title: 'Dashboard',
            iconData: Icons.dashboard_outlined,
            isSelected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Inventory',
            iconData: Icons.inventory_2_outlined,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Shopping List',
            iconData: Icons.shopping_cart_outlined,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Suggestions',
            iconData: Icons.lightbulb_outline,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          _buildDrawerItem(
            title: 'Settings',
            iconData: Icons.settings_outlined,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Help & Support',
            iconData: Icons.help_outline,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Logout',
            iconData: Icons.logout,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Widget for each item in the drawer
  Widget _buildDrawerItem({
    required String title,
    required IconData iconData,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        iconData,
        color: isSelected ? AppColors.primary : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.text,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
    );
  }

  // Bottom navigation bar to switch between main sections
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Shopping',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
