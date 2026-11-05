import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting & Micro Status Context
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('Good evening, Alex', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF131B2E))),
                        SizedBox(width: 4),
                        Text('👋', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: const [
                        Icon(Icons.location_on, size: 14, color: Color(0xFF10B981)),
                        SizedBox(width: 4),
                        Text('Apt 4B, 742 Evergreen Terr • 12m away', style: TextStyle(fontSize: 13, color: Color(0xFF3C4A42))),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF97F5CC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                        width: 8,
                        height: 8,
                        child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                      ),
                      SizedBox(width: 6),
                      Text('1 ACTIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00513A))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live Telemetry Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF006C49), Color(0xFF00422B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
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
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('LIVE DISPATCH • 18 MIN ETA', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.sensors, color: Colors.white70, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Artisan Bakery Box is on the way', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Courier Marcus is 1.2 miles away on an e-bike, heading down Maple Ave.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(value: 0.78, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.two_wheeler, color: Colors.white, size: 16),
                          ),
                          SizedBox(width: 8),
                          Text('Marcus S. • ★ 4.98', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF00422B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        child: Row(
                          children: const [
                            Text('Track Live Map', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Action Shortcut Hub (Fixed icons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction(Icons.radar, 'Track Order', const Color(0xFF97F5CC), const Color(0xFF006C4E)),
                _buildQuickAction(Icons.inventory_2, 'Send Box', const Color(0xFFE2E7FF), const Color(0xFF006C49)),
                _buildQuickAction(Icons.favorite, 'Saved Spots', const Color(0xFFDCE1FF), const Color(0xFF2151DA)),
                _buildQuickAction(Icons.support_agent, 'Support', const Color(0xFFEAEDFF), const Color(0xFF3C4A42)),
              ],
            ),
            const SizedBox(height: 20),

            // Ongoing Order Master Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Ongoing Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF131B2E))),
                Text('Order Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006C49))),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network('https://lh3.googleusercontent.com/aida-public/AB6AXuAZbcJbVBJDmIrBXNCGunsT-x-qZ4xU7GUrtFlOBAcTNqq_Zd9KAJXCKKVyzFg1j0Fmo67jTe9VI8XjOpWRPy-7zYgDGTj5CWcARwXFDqQaeTgmw1n_DvuaX2uJCLkiSW9nH4Ll99YvXVbOruIzfbkqcG4vE-a6D-u2UMZT3--ZF-2E5Xtxom9rFLU8G5WuSTkZAdi_5uw9HXPukxo3BUb23qIkzzs-TJdXWuw8E7dO', width: 52, height: 52, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Artisan Sourdough & Patisserie', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF131B2E))),
                            SizedBox(height: 2),
                            Text('3 items • \$42.50 • Order #8921', style: TextStyle(fontSize: 12, color: Color(0xFF3C4A42))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF97F5CC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Out for Delivery', style: TextStyle(color: Color(0xFF00513A), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('DISPATCHED (3:42 PM)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006C49))),
                      Text('EST. ARRIVAL 4:02 PM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6C7A71))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const LinearProgressIndicator(value: 0.75, backgroundColor: Color(0xFFEAEDFF), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981))),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFF2F3FF), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBydXI-j4CcXstUTjcnTsGLTvR5XxZTbDZcaxJB_kRpWB-pOm6Pm3xmNILTMKABRatgTrCGVoFzCfkQMeQtsN6nz8EPcBwX5I2j9ITxKLp8nb-68QXah3XnKkjOqTXs1f1PjxAGlBpzQJgqjDNghCs40UePLnNBKpW8GkcZAD3Y6yCRLonw4_Jfx465g95v8ONOtNHbxnxKoREp8T4i5MVE6ODPB2soIem6WReK0NqI')),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Marcus Vance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF131B2E))),
                              Text('Special instructions noted', style: TextStyle(fontSize: 11, color: Color(0xFF3C4A42))),
                            ],
                          ),
                        ),
                        Row(
                          children: const [
                            CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.call, size: 16, color: Color(0xFF131B2E))),
                            SizedBox(width: 8),
                            CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.chat, size: 16, color: Color(0xFF131B2E))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color bg, Color fg) {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: fg, size: 20),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF131B2E)), textAlign: TextAlign.center),
        ],
      ),
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