import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Correct import paths pointing to the screens folder
import 'screens/home_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
      // Fixed typo: initialRoute instead of intialRoute
      initialRoute: '/',
      
      // Removed 'const' from screen instances inside route builders
      routes: {
        '/': (context) => HomeScreen(),
        '/delivery': (context) => DeliveryScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}