import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'delivery_screen.dart';
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
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          height: 65,
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFECFDF5),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Color(0xFF64748B)),
              selectedIcon: Icon(Icons.home, color: Color(0xFF10B981)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined, color: Color(0xFF64748B)),
              selectedIcon: Icon(Icons.local_shipping, color: Color(0xFF10B981)),
              label: 'Tracking',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Color(0xFF64748B)),
              selectedIcon: Icon(Icons.person, color: Color(0xFF10B981)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}