import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../delivery_provider.dart';

class DeliveryScreen extends ConsumerWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryState = ref.watch(deliveryProvider);
    final deliveryNotifier = ref.read(deliveryProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Tracking ${deliveryState.orderId}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Hero Card for ETA & Status
            _buildEtaHeroCard(deliveryState),
            const SizedBox(height: 20),

            // Stepper
            _buildStatusStepper(deliveryState.status),
            const SizedBox(height: 20),

            // Driver Contact Card
            if (deliveryState.status == DeliveryStatus.outForDelivery) ...[
              _buildDriverCard(deliveryState),
              const SizedBox(height: 20),
            ],

            // Delivery Address Tile
            _buildAddressCard(deliveryState.deliveryAddress),
            const SizedBox(height: 20),

            // Itemized Order Details Card
            _buildOrderDetailsCard(deliveryState),
            const SizedBox(height: 28),

            // Interactive Action Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => deliveryNotifier.advanceStatus(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Simulate Next Delivery Stage',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEtaHeroCard(DeliveryState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ESTIMATED DELIVERY',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
              const SizedBox(height: 6),
              Text(
                state.estimatedTime,
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          _buildStatusBadge(state.status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(DeliveryStatus status) {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case DeliveryStatus.placed:
        text = 'Order Placed';
        bgColor = const Color(0xFFEFF6FF);
        textColor = const Color(0xFF1D4ED8);
        break;
      case DeliveryStatus.preparing:
        text = 'Preparing';
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFB45309);
        break;
      case DeliveryStatus.outForDelivery:
        text = 'Out for Delivery';
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF047857);
        break;
      case DeliveryStatus.delivered:
        text = 'Delivered';
        bgColor = const Color(0xFFF3E8FF);
        textColor = const Color(0xFF6B21A8);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildStatusStepper(DeliveryStatus currentStatus) {
    final statuses = [
      {'title': 'Placed', 'status': DeliveryStatus.placed},
      {'title': 'Preparing', 'status': DeliveryStatus.preparing},
      {'title': 'On the Way', 'status': DeliveryStatus.outForDelivery},
      {'title': 'Delivered', 'status': DeliveryStatus.delivered},
    ];

    int currentIndex = statuses.indexWhere((e) => e['status'] == currentStatus);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(statuses.length, (index) {
          final isCompleted = index <= currentIndex;
          final isCurrent = index == currentIndex;

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? (isCurrent ? const Color(0xFF10B981) : const Color(0xFFA7F3D0))
                        : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
                    size: 14,
                    color: isCompleted ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  statuses[index]['title'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCompleted ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDriverCard(DeliveryState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF10B981), width: 2),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFF1F5F9),
              child: Icon(Icons.person, color: Color(0xFF475569)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.driverName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Courier • Honda PCX',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(14)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.phone, color: Color(0xFF10B981), size: 20),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(14)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF3B82F6), size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(String address) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.location_on_outlined, color: Color(0xFFEF4444), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DELIVERY DESTINATION',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsCard(DeliveryState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          ...state.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${item.quantity}x',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(item.name, style: const TextStyle(color: Color(0xFF334155), fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                  ],
                ),
              )),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee', style: TextStyle(color: Color(0xFF64748B))),
              Text('\$${state.deliveryFee.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
              Text(
                '\$${state.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF10B981)),
              ),
            ],
          ),
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
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 18,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}