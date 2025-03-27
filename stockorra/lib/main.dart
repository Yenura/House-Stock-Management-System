import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stockorra/screens/dashboard/dashboard_screen.dart';
import 'package:stockorra/screens/inventory/inventory_home_screen.dart';
import 'package:stockorra/screens/analytics/analytics_screen.dart';
import 'package:stockorra/screens/notifications/notifications_screen.dart';
import 'package:stockorra/screens/profile/profile_screen.dart';
import 'package:stockorra/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Stockorra',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService().navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          fontFamily: 'Roboto',
        ),
        initialRoute: Routes.launch1,
        routes: Routes.getRoutes(),
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
