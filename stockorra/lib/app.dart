import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/providers/auth_provider.dart';
import 'package:stockorra/screens/auth/login_screen.dart';
import 'package:stockorra/utils/constants.dart';
import 'package:stockorra/utils/theme.dart';

class StockorraApp extends StatelessWidget {
  const StockorraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          // Add other routes as needed
        },
      ),
    );
  }
}
//.