import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stockorra/config/firebase_config.dart';
import 'package:stockorra/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:stockorra/services/firebase_service.dart';
import 'package:stockorra/services/notification_service.dart';
import 'package:stockorra/services/ml_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseService()),
        ChangeNotifierProvider(create: (_) => MLService()),
      ],
      child: MaterialApp(
        title: 'Stockorra',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const DashboardScreen(),
      ),
    );
  }
}