import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'delivery_screen.dart';
import 'orders_screen.dart'; // Import the new screen
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    DeliveryScreen(),
    OrdersScreen(), // Dedicated Orders Screen here
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      // ... (Keep the rest of your AppBar and NavigationBar code exactly as it was)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.05),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          height: 65,
          elevation: 0,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF97F5CC),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Color(0xFF3C4A42)),
              selectedIcon: Icon(Icons.home, color: Color(0xFF006C49)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.near_me_outlined, color: Color(0xFF3C4A42)),
              selectedIcon: Icon(Icons.near_me, color: Color(0xFF006C49)),
              label: 'Live Track',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined, color: Color(0xFF3C4A42)),
              selectedIcon: Icon(Icons.receipt_long, color: Color(0xFF006C49)),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Color(0xFF3C4A42)),
              selectedIcon: Icon(Icons.person, color: Color(0xFF006C49)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}