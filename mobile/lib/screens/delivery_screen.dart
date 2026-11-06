import 'package:flutter/material.dart';
import '../models/order_model.dart';

class DeliveryScreen extends StatelessWidget {
  final OrderModel order;
  const DeliveryScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
  title: const Text('Live Dispatch Tracking', style: TextStyle(color: Color(0xFF131B2E), fontWeight: FontWeight.bold)),
  backgroundColor: Colors.white,
  elevation: 0,
  iconTheme: const IconThemeData(color: Color(0xFF131B2E)), // Fixed here
),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ETA Obsidian Telemetry Hero Card (Connected to order model)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF97F5CC), borderRadius: BorderRadius.circular(20)),
                        child: Text(order.status.toUpperCase().replaceAll('_', ' '), style: const TextStyle(color: Color(0xFF002115), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.speed, size: 14, color: Color(0xFF4EDEA3)),
                          SizedBox(width: 4),
                          Text('Telemetry Live', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(order.estimatedTime, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Text('(Live ETA)', style: TextStyle(color: Color(0xFF4EDEA3), fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('En route to ${order.deliveryAddress}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.battery_charging_full, size: 16, color: Color(0xFF6FFBBE)),
                          SizedBox(width: 4),
                          Text('Scooter: 88%', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.thermostat, size: 16, color: Color(0xFF6FFBBE)),
                          SizedBox(width: 4),
                          Text('Bag Temp: 64°C Optimal', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stepper Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('ORDER STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3C4A42))),
                          Text('Step 3 of 4 Completed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF131B2E))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF97F5CC), borderRadius: BorderRadius.circular(20)),
                        child: Text(order.orderIdString, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF007353))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStepItem('Placed', '7:10 PM', true, true),
                      _buildStepItem('Prepared', '7:25 PM', true, true),
                      _buildStepItem('Delivering', '7:35 PM', true, false, isActive: true),
                      _buildStepItem('Delivered', 'Est.', false, false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Courier Contact Card (Connected to order.driverName)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 26, backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCTgzbxbUOIj4MmpDzj888XcbQiVHTzGcahf3MCi887xWOZ4cx45AyQq3E2m2tGuKZCrpbcJkxIxj_cE9s7GBUbah_1nSBbUIo-lSCJ_j6VrKILouHaovmYvgbFftYkKYsxBaEnoRDRSIyb4YgXFpnSYhMF4HYGzJS1u2iADLCtDXC0ltGdvk6qR729pcjWRLDRoeyCvIyBwNjdP-9fH9HYt6LwYm1vQxu45ETT_4Zt')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(order.driverName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF131B2E))),
                                const SizedBox(width: 6),
                                const Text('4.9 ★', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF006C49))),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text('Green E-Scooter • Plate: NY-8820', style: TextStyle(fontSize: 12, color: Color(0xFF3C4A42))),
                            const Text('Top Rated • 1,420+ safe drops', style: TextStyle(fontSize: 10, color: Color(0xFF6C7A71))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call, size: 18, color: Color(0xFF007353)),
                          label: Text('Call ${order.driverName.split(' ').first}', style: const TextStyle(color: Color(0xFF007353), fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF97F5CC), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), minimumSize: const Size(0, 44)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat, size: 18, color: Color(0xFF131B2E)),
                          label: const Text('Chat', style: TextStyle(color: Color(0xFF131B2E), fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE2E7FF), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), minimumSize: const Size(0, 44)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String title, String time, bool isDone, bool showLine, {bool isActive = false}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFF10B981) : (isActive ? const Color(0xFF97F5CC) : const Color(0xFFEAEDFF)),
            shape: BoxShape.circle,
          ),
          child: Icon(isDone ? Icons.check : Icons.electric_moped, size: 16, color: isDone ? Colors.white : (isActive ? const Color(0xFF006C49) : const Color(0xFF6C7A71))),
        ),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? const Color(0xFF006C49) : const Color(0xFF131B2E))),
        Text(time, style: const TextStyle(fontSize: 9, color: Color(0xFF6C7A71))),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      boxShadow: [
        BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 5)),
      ],
    );
  }
}