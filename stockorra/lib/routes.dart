import 'package:flutter/material.dart';
import 'package:stockorra/models/user_model.dart';
import 'package:stockorra/models/shopping_item.dart';
import 'package:stockorra/screens/auth/forgot_password_screen.dart';
import 'package:stockorra/screens/auth/login_screen.dart';
import 'package:stockorra/screens/auth/signup_screen.dart';
import 'package:stockorra/screens/auth/verification_screen.dart';
import 'package:stockorra/screens/launch/launch_screen_1.dart';
import 'package:stockorra/screens/launch/launch_screen_2.dart';
import 'package:stockorra/screens/launch/launch_screen_3.dart';
import 'package:stockorra/screens/onboarding/onboarding_screens.dart';
import 'package:stockorra/screens/dashboard/dashboard_screen.dart';
import 'package:stockorra/screens/inventory/inventory_home_screen.dart';
import 'package:stockorra/screens/inventory/inventory_add_screen.dart';
import 'package:stockorra/screens/inventory/inventory_list_screen.dart';
import 'package:stockorra/screens/inventory/edit_inventory_screen.dart';
import 'package:stockorra/screens/profile/profile_screen.dart';
import 'package:stockorra/screens/profile/add_user_screen.dart';
import 'package:stockorra/screens/profile/edit_user_screen.dart';
import 'package:stockorra/screens/profile/settings_screen.dart';
import 'package:stockorra/screens/profile/household_list_screen.dart';
import 'package:stockorra/screens/shopping/shopping_list_screen.dart';
import 'package:stockorra/screens/shopping/shopping_list_add_screen.dart';
import 'package:stockorra/screens/shopping/edit_shopping_list_screen.dart';
import 'package:stockorra/screens/notifications/notifications_screen.dart';
import 'package:stockorra/screens/analytics/analytics_screen.dart';
import 'package:stockorra/screens/prediction/expiry_prediction_screen.dart';
import 'package:stockorra/screens/reports/usage_reports_screen.dart';
import 'package:stockorra/screens/prediction/suggestion_screen.dart';
import 'package:stockorra/services/inventory_service.dart';

class Routes {
  static final inventoryService = InventoryService();

  // Launch and Onboarding
  static const String launch1 = '/launch1';
  static const String launch2 = '/launch2';
  static const String launch3 = '/launch3';
  static const String onboarding = '/onboarding';

  // Authentication
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verification = '/verification';

  // Main Screens
  static const String dashboard = '/dashboard';
  static const String inventoryHome = '/inventory';
  static const String inventoryAdd = '/inventory/add';
  static const String inventoryList = '/inventory/list';
  static const String inventoryEdit = '/inventory/edit';
  static const String profile = '/profile';
  static const String addUser = '/profile/add-user';
  static const String editUser = '/profile/edit-user';
  static const String settings = '/settings';
  static const String shoppingList = '/shopping-list';
  static const String shoppingListAdd = '/shopping-list/add';
  static const String shoppingListEdit = '/shopping-list/edit';
  static const String notifications = '/notifications';
  static const String analytics = '/analytics';
  static const String expiryPrediction = '/expiry-prediction';
  static const String usageReports = '/prediction/usage-analytics';
  static const String suggestion = '/suggestion';
  static const String householdList = '/profile/household-list';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Launch and Onboarding
      launch1: (context) => const LaunchScreen1(),
      launch2: (context) => const LaunchScreen2(),
      launch3: (context) => const LaunchScreen3(),
      onboarding: (context) => const OnboardingScreens(),

      // Authentication
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      verification: (context) => const VerificationScreen(),

      // Main Screens
      dashboard: (context) => const DashboardScreen(),
      inventoryHome: (context) =>
          InventoryHomeScreen(inventoryService: inventoryService),
      inventoryAdd: (context) =>
          InventoryAddScreen(inventoryService: inventoryService),
      inventoryList: (context) =>
          InventoryListScreen(inventoryService: inventoryService),
      profile: (context) => const ProfileScreen(),
      addUser: (context) => const AddUserScreen(),
      settings: (context) => const SettingsScreen(),
      shoppingList: (context) => const ShoppingListScreen(),
      shoppingListAdd: (context) => const ShoppingListAddScreen(),
      notifications: (context) => const NotificationsScreen(),
      analytics: (context) => const AnalyticsScreen(),
      expiryPrediction: (context) => const ExpiryPredictionScreen(),
      usageReports: (context) => const UsageReportsScreen(),
      suggestion: (context) => const SuggestionScreen(),
      householdList: (context) => const HouseholdListScreen(),
    };
  }

  // For routes that need parameters
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case inventoryEdit:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => EditInventoryScreen(
            docId: args['docId'],
            initialData: args['initialData'],
            inventoryService: inventoryService,
          ),
        );
      case shoppingListEdit:
        if (settings.arguments is! ShoppingItem) {
          throw Exception(
              'EditShoppingListScreen requires a ShoppingItem object as argument');
        }
        return MaterialPageRoute(
          builder: (context) =>
              EditShoppingListScreen(item: settings.arguments as ShoppingItem),
        );
      case editUser:
        if (settings.arguments is! User) {
          throw Exception('EditUserScreen requires a User object as argument');
        }
        return MaterialPageRoute(
          builder: (context) =>
              EditUserScreen(user: settings.arguments as User),
        );
      default:
        return null;
    }
  }
}
