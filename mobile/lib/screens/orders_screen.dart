import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        title: const Text(
          'Order & Receipt History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF131B2E)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ACTIVE & RECENT DELIVERIES',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C7A71), letterSpacing: 0.8),
            ),
            const SizedBox(height: 12),
            
            // Order 1: Active
            _buildOrderCard(
              title: 'Artisan Sourdough & Patisserie',
              details: '3 items • \$42.50 • Order #8921',
              statusText: 'Out for Delivery',
              statusBg: const Color(0xFF97F5CC),
              statusFg: const Color(0xFF00513A),
              dateInfo: 'Dispatched today, 3:42 PM',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAZbcJbVBJDmIrBXNCGunsT-x-qZ4xU7GUrtFlOBAcTNqq_Zd9KAJXCKKVyzFg1j0Fmo67jTe9VI8XjOpWRPy-7zYgDGTj5CWcARwXFDqQaeTgmw1n_DvuaX2uJCLkiSW9nH4Ll99YvXVbOruIzfbkqcG4vE-a6D-u2UMZT3--ZF-2E5Xtxom9rFLU8G5WuSTkZAdi_5uw9HXPukxo3BUb23qIkzzs-TJdXWuw8E7dO',
              actionLabel: 'Track Live',
              onAction: () {},
            ),
            const SizedBox(height: 12),

            // Order 2: Delivered
            _buildOrderCard(
              title: 'Green Garden Bowls',
              details: 'Salmon Poke Bowl + Green Detox',
              statusText: 'Delivered',
              statusBg: const Color(0xFFF3E8FF),
              statusFg: const Color(0xFF6B21A8),
              dateInfo: 'Yesterday, 1:15 PM • \$24.80',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAnJulwqZ4-ks3s0e7tlMyIYDdaIb637D8d3nSR8t5MkxavFqOOY7QCFEYDp_dHpZlQZKENBILyw4Pen54efB-nfGinzARV1dzjiQwyrf4FatwIa53FELzp7mxKOHyskvigMEKHhm9hvmmXRwHPP3rihOeNJODFc3lSxBATQSBNeRrU71ERPI8uIky9MvcSE-H6Td5fL5TfUrlxyawpaEqsSRPRrHtgM1Xv69ehQTxu',
              actionLabel: 'Reorder',
              onAction: () {},
            ),
            const SizedBox(height: 12),

            // Order 3: Completed
            _buildOrderCard(
              title: 'Urban Roast Coffee Lab',
              details: 'Cold Brew Concentrate & Everything Bagel',
              statusText: 'Completed',
              statusBg: const Color(0xFFDCE1FF),
              statusFg: const Color(0xFF002D95),
              dateInfo: 'Oct 24 • \$16.20',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCRpx2gsnkXKWe9RI46b3avWmpLrjOkfl6fmF1hyFW87LKjZXHei56G6gBzd7tmscsULke5n7gQ0mEqhxPGy1HFMmLZ30YK_yLBuMeeKwcpBvqb9Ig3TvudGUe8LOugC530I_zRmyvV4lrErA0INl7jYMigPSkN-UKMWzX2jomeOXQyPdzB956JNhy3ujcQaogBBQ6g4xD4hZjQ9G2XlOhvN3VW14g1XJM5P1EVXKr-',
              actionLabel: 'Reorder',
              onAction: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String title,
    required String details,
    required String statusText,
    required Color statusBg,
    required Color statusFg,
    required String dateInfo,
    required String imageUrl,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, width: 56, height: 56, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF131B2E)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF3C4A42)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusFg, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateInfo,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6C7A71), fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2F3FF),
                  foregroundColor: const Color(0xFF131B2E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(actionLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}