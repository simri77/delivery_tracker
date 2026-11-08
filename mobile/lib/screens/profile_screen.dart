  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import '../services/shared_prefs_helper.dart';
  import '../services/secure_storage_helper.dart';
  import 'login_screen.dart';

  class ProfileScreen extends StatefulWidget {
    const ProfileScreen({Key? key}) : super(key: key);

    Future<void> _handleLogout(BuildContext context) async {
    // Clear the encrypted token from secure storage
    await SecureStorageHelper.clearToken();

    if (!context.mounted) return;

    // Navigate to LoginScreen and clear the entire navigation history stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Removes all previous screens so the user can't press back
    );
  }
    @override
    State<ProfileScreen> createState() => _ProfileScreenState();
  }

  class _ProfileScreenState extends State<ProfileScreen> {
    bool contactlessDropoff = true;
    bool ecoElectricDispatch = true;
    late Future futureUserProfile;

    @override
    void initState() {
      super.initState();
      futureUserProfile = fetchUserProfile();
    }

    Future fetchUserProfile() async {
      try {
        final response = await http.get(Uri.parse('http://localhost:5000/api/user/profile'));
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          throw Exception('Failed to load profile');
        }
      } catch (e) {
        return {
          'name': 'Alexandria Rivera',
          'email': 'alex.rivera@deliverymail.com',
          'phone': '+1 (555) 382-9102',
          'tier': 'Gold Tier Member',
          'points': '4,820',
        };
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF8FF),
        body: FutureBuilder(
          future: futureUserProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
            }

            final user = (snapshot.data ?? {}) as Map;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  await SecureStorageHelper.saveToken(data['token']);
                  // User Identity & Metrics Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F3FF),
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDmKy34lFYSj8StcN6olagXaoqJKpa5IppYxS6Sf7EuBewns67tWQfgaqiCnrnTucvvACzlfgN8qNLs-RoxSrM6iPT2TKT9jWpersA7qx_OGZGzejNBxJXg-L-P_g-8nnjNTLAUHMeAtusJloQnKocACaFJ_Bdgs3BlFdyEfm2JhPyzSydcGHsnIuBzWkdIXM3Q7qjjWvXqlpfw5_lU2qIn4ZzglRF88kFLiNTK4H9v'),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        await SecureStorageHelper.clearToken();
                        const SizedBox(height: 12),
                        Text(
                          user['name'] ?? 'Alexandria Rivera',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF131B2E)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${user['email'] ?? 'alex.rivera@deliverymail.com'} • ${user['phone'] ?? '+1 (555) 382-9102'}',
                          style: const TextStyle(color: Color(0xFF6C7A71), fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.stars, size: 14, color: Color(0xFFB45309)),
                              const SizedBox(width: 4),
                              Text(
                                '${user['tier'] ?? 'Gold Tier'} • ${user['points'] ?? '4,820'} Courier Points',
                                style: const TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F3FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMetricItem('48', 'Orders', const Color(0xFF131B2E)),
                              _buildMetricItem('98%', 'On-Time', const Color(0xFF10B981)),
                              _buildMetricItem('\$124', 'Saved Gold', const Color(0xFF131B2E)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fast Courier Preferences
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'FAST COURIER PREFERENCES',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C7A71), letterSpacing: 0.8),
                            ),
                            Row(
                              children: [
                                Icon(Icons.bolt, size: 14, color: Color(0xFF10B981)),
                                Text(
                                  'Live Sync',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildToggleRow(
                          icon: Icons.meeting_room,
                          iconColor: const Color(0xFF007353),
                          bgColor: const Color(0xFF97F5CC).withOpacity(0.4),
                          title: 'Contactless Drop-off',
                          subtitle: 'Leave at front door with photo confirmation',
                          value: contactlessDropoff,
                          onChanged: (val) => setState(() => contactlessDropoff = val),
                        ),
                        const SizedBox(height: 12),
                        _buildToggleRow(
                          icon: Icons.electric_bolt,
                          iconColor: const Color(0xFF00513A),
                          bgColor: const Color(0xFF97F5CC).withOpacity(0.5),
                          title: 'Eco Electric Dispatch',
                          subtitle: 'Priority routing via EV moped & e-cargo',
                          value: ecoElectricDispatch,
                          onChanged: (val) => setState(() => ecoElectricDispatch = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Account & Logistics Settings Tiles
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ACCOUNT & LOGISTICS SETTINGS',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C7A71), letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 8),
                        _buildTile(Icons.location_on, const Color(0xFFDC2626), const Color(0xFFFEF2F2), 'Saved Addresses', 'Home, Work, Gym (3 locations)'),
                        _buildTile(Icons.receipt_long, const Color(0xFF1D4ED8), const Color(0xFFEFF6FF), 'Order & Receipt History', 'View past deliveries and re-order'),
                        _buildTile(Icons.account_balance_wallet, const Color(0xFF047857), const Color(0xFFECFDF5), 'Payment Methods & Wallet', 'Apple Pay, Visa •••• 4092 • \$35.00 Balance'),
                        _buildTile(Icons.notifications_active, const Color(0xFFB45309), const Color(0xFFFEF3C7), 'Notifications & Alerts', 'SMS, Push, Live Courier ETA Tracking'),
                        _buildTile(Icons.volunteer_activism, const Color(0xFF6B21A8), const Color(0xFFF3E8FF), 'Courier Tip Preferences', 'Default 15% courier appreciation'),
                        _buildTile(Icons.support_agent, const Color(0xFF131B2E), const Color(0xFFE2E7FF), 'Safety & Support', '24/7 Priority Courier Concierge'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Logout Action
  SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton.icon(
      onPressed: () async {
        // 1. Clear the saved JWT token
        await SharedPrefsHelper.clearToken();

        if (!context.mounted) return;

        // 2. Navigate to LoginScreen and remove all previous routes from stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      },
      icon: const Icon(Icons.logout, size: 18, color: Color(0xFFBA1A1A)),
      label: const Text('Log Out', style: TextStyle(color: Color(0xFFBA1A1A), fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFDAD6).withOpacity(0.4),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  ),,
                  const SizedBox(height: 16),
                  const Text('PRECISION DELIVERY TELEMETRY ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6C7A71), letterSpacing: 1.0)),
                  const SizedBox(height: 2),
                  const Text('Version 3.4.2 (Precision Delivery Build)', style: TextStyle(fontSize: 10, color: Color(0xFFBBCABF))),
                ],
              ),
            );
          },
        ),
      );
    }

    Widget _buildMetricItem(String val, String label, Color color) {
      return Column(
        children: [
          Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6C7A71))),
        ],
      );
    }

    Widget _buildToggleRow({
      required IconData icon,
      required Color iconColor,
      required Color bgColor,
      required String title,
      required String subtitle,
      required bool value,
      required ValueChanged<bool> onChanged,
    }) {
      return Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF131B2E))),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6C7A71))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF10B981),
          ),
        ],
      );
    }

    Widget _buildTile(IconData icon, Color iconColor, Color bgColor, String title, String subtitle) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF131B2E))),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6C7A71)), overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFFBBCABF)),
        onTap: () {},
      );
    }

    BoxDecoration _cardDecoration() {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      );
    }
  }