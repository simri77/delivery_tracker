import 'package:flutter/material.dart';
import 'models/order_model.dart';
import 'screens/home_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const DeliveryTrackerApp());
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final OrderModel sampleOrder = OrderModel(
    id: 1,
    orderIdString: 'ORD-8921',
    status: 'out_for_delivery',
    estimatedTime: '18 min ETA',
    driverName: 'Marcus Vance',
    deliveryAddress: 'Apt 4B, 742 Evergreen Terr',
    totalPrice: 42.50,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onNavigateTab: (index) {
          setState(() {
            _currentIndex = index; // Switches tab programmatically!
          });
        },
      ),
      DeliveryScreen(order: sampleOrder),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: const Color(0xFF6C7A71),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Delivery'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DeliveryTrackerApp extends StatelessWidget {
  const DeliveryTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // Or your default font
        scaffoldBackgroundColor: const Color(0xFFFAF8FF),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Sample order instance to satisfy DeliveryScreen's required parameter
  final OrderModel sampleOrder = OrderModel(
    id: 1,
    orderIdString: 'ORD-8921',
    status: 'out_for_delivery',
    estimatedTime: '18 min ETA',
    driverName: 'Marcus Vance',
    deliveryAddress: 'Apt 4B, 742 Evergreen Terr',
    totalPrice: 42.50,
  );

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      DeliveryScreen(order: sampleOrder),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF10B981),
          unselectedItemColor: const Color(0xFF6C7A71),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              activeIcon: Icon(Icons.local_shipping),
              label: 'Delivery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}