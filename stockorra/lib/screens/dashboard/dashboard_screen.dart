import 'package:flutter/material.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/routes.dart';
import 'package:stockorra/widgets/dashboard_card.dart';
import 'package:stockorra/screens/inventory/inventory_home_screen.dart';
import 'package:stockorra/screens/shopping/shopping_list_screen.dart';
import 'package:stockorra/screens/profile/profile_screen.dart';
import 'package:stockorra/screens/reports/usage_reports_screen.dart';
import 'package:stockorra/screens/analytics/analytics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/stockorra_logo.png',
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              AppStrings.appName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return InventoryHomeScreen(inventoryService: Routes.inventoryService);
      case 2:
        return const ShoppingListScreen();
      case 3:
        return const UsageReportsScreen();
      case 4:
        return const AnalyticsScreen();
      case 5:
        return const ProfileScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 15),
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
                        setState(() => _selectedIndex = 1);
                      },
                    ),
                    DashboardCard(
                      title: 'Shopping List',
                      subtitle: 'Things to buy',
                      iconData: Icons.shopping_cart,
                      color: Colors.green,
                      onTap: () {
                        setState(() => _selectedIndex = 2);
                      },
                    ),
                    DashboardCard(
                      title: 'Usage Reports',
                      subtitle: 'Track usage',
                      iconData: Icons.bar_chart,
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.usageReports);
                      },
                    ),
                    DashboardCard(
                      title: 'Analytics',
                      subtitle: 'View insights',
                      iconData: Icons.analytics,
                      color: Colors.amber,
                      onTap: () {
                        setState(() => _selectedIndex = 4);
                      },
                    ),
                    DashboardCard(
                      title: 'Expiry Tracking',
                      subtitle: 'Monitor expiry dates',
                      iconData: Icons.timer_outlined,
                      color: Colors.red,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.expiryPrediction);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child:
                      Icon(Icons.person, size: 35, color: theme.primaryColor),
                ),
                const SizedBox(height: 10),
                const Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'user@email.com',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            title: 'Dashboard',
            iconData: Icons.dashboard_outlined,
            isSelected: _selectedIndex == 0,
            onTap: () {
              setState(() => _selectedIndex = 0);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Inventory',
            iconData: Icons.inventory_2_outlined,
            isSelected: _selectedIndex == 1,
            onTap: () {
              setState(() => _selectedIndex = 1);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Shopping List',
            iconData: Icons.shopping_cart_outlined,
            isSelected: _selectedIndex == 2,
            onTap: () {
              setState(() => _selectedIndex = 2);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Usage Reports',
            iconData: Icons.bar_chart_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.usageReports);
            },
          ),
          _buildDrawerItem(
            title: 'Analytics',
            iconData: Icons.analytics_outlined,
            isSelected: _selectedIndex == 4,
            onTap: () {
              setState(() => _selectedIndex = 4);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Expiry Tracking',
            iconData: Icons.timer_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.expiryPrediction);
            },
          ),
          const Divider(),
          _buildDrawerItem(
            title: 'Profile',
            iconData: Icons.person_outline,
            isSelected: _selectedIndex == 5,
            onTap: () {
              setState(() => _selectedIndex = 5);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            title: 'Settings',
            iconData: Icons.settings_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
          _buildDrawerItem(
            title: 'Logout',
            iconData: Icons.logout,
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                // TODO: Implement logout functionality
                Navigator.pushReplacementNamed(context, Routes.login);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData iconData,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        iconData,
        color: isSelected ? theme.primaryColor : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? theme.primaryColor
              : theme.textTheme.titleMedium?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: theme.primaryColor.withOpacity(0.1),
    );
  }

  Widget _buildBottomNavigationBar() {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: theme.primaryColor,
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
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Usage',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
