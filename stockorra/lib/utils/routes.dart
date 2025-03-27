import 'package:flutter/material.dart';
import 'package:stockorra/screens/auth/login_screen.dart';
import 'package:stockorra/screens/auth/signup_screen.dart';
import 'package:stockorra/screens/auth/forgot_password_screen.dart';
import 'package:stockorra/screens/auth/verification_screen.dart';
import 'package:stockorra/screens/dashboard/dashboard_screen.dart';
import 'package:stockorra/screens/profile/profile_screen.dart';
import 'package:stockorra/screens/profile/settings_screen.dart';
import 'package:stockorra/screens/profile/edit_user_screen.dart';
import 'package:stockorra/screens/profile/add_user_screen.dart';
import 'package:stockorra/screens/inventory/inventory_home_screen.dart';
import 'package:stockorra/screens/inventory/inventory_add_screen.dart';
import 'package:stockorra/screens/inventory/inventory_detail_screen.dart';
import 'package:stockorra/screens/shopping/shopping_list_screen.dart';
import 'package:stockorra/screens/shopping/shopping_list_add_screen.dart';
import 'package:stockorra/screens/prediction/usage_analytics_screen.dart';
import 'package:stockorra/screens/prediction/expiry_prediction_screen.dart';
import 'package:stockorra/services/inventory_service.dart';

class Routes {
  static final inventoryService = InventoryService();
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verification = '/verification';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String editUser = '/edit-user';
  static const String addUser = '/add-user';
  static const String inventory = '/inventory';
  static const String inventoryAdd = '/inventory/add';
  static const String inventoryDetail = '/inventory/detail';
  static const String shoppingList = '/shopping-list';
  static const String shoppingListAdd = '/shopping-list/add';
  static const String usageReports = '/prediction/usage-analytics';
  static const String expiryPrediction = '/prediction/expiry-prediction';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      verification: (context) => const VerificationScreen(),
      dashboard: (context) => const DashboardScreen(),
      profile: (context) => const ProfileScreen(),
      settings: (context) => const SettingsScreen(),
      addUser: (context) => const AddUserScreen(),
      inventory: (context) =>
          InventoryHomeScreen(inventoryService: inventoryService),
      inventoryAdd: (context) =>
          InventoryAddScreen(inventoryService: inventoryService),
      shoppingList: (context) => const ShoppingListScreen(),
      shoppingListAdd: (context) => const ShoppingListAddScreen(),
      usageReports: (context) => const UsageAnalyticsScreen(),
      expiryPrediction: (context) => const ExpiryPredictionScreen(),
    };
  }

  // For routes that need parameters
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case editUser:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => EditUserScreen(user: args['user']),
        );
      case inventoryDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => InventoryDetailScreen(item: args['item']),
        );
      case usageReports:
        return MaterialPageRoute(
          builder: (context) => const UsageAnalyticsScreen(),
        );
      case expiryPrediction:
        return MaterialPageRoute(
          builder: (context) => const ExpiryPredictionScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
