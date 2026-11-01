import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../delivery_provider.dart'; // Fixed relative path to look in lib/

class DeliveryScreen extends ConsumerWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the state so the UI rebuilds automatically whenever data changes
    final deliveryState = ref.watch(deliveryProvider);
    // 2. Get the notifier to trigger actions (like advancing the order status)
    final deliveryNotifier = ref.read(deliveryProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          'Track Delivery (${deliveryState.orderId})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estimated Arrival Banner
            _buildEtaCard(deliveryState),
            const SizedBox(height: 16),

            // Stepper Status Indicator
            _buildStatusStepper(deliveryState.status),
            const SizedBox(height: 16),

            // Driver Info Card (Shows when out for delivery)
            if (deliveryState.status == DeliveryStatus.outForDelivery) ...[
              _buildDriverCard(context, deliveryState),
              const SizedBox(height: 16),
            ],

            // Delivery Location
            _buildAddressCard(deliveryState.deliveryAddress),
            const SizedBox(height: 16),

            // Order Items & Summary
            _buildOrderDetailsCard(deliveryState),
            const SizedBox(height: 24),

            // Interactive Demo Button to trigger Riverpod state changes
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => deliveryNotifier.advanceStatus(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

  Widget _buildEtaCard(DeliveryState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated Delivery Time',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            state.estimatedTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

    int currentIndex = statuses.indexWhere((element) => element['status'] == currentStatus);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(statuses.length, (index) {
          final isCompleted = index <= currentIndex;
          final isCurrent = index == currentIndex;

          return Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isCompleted
                      ? (isCurrent ? const Color(0xFF10B981) : Colors.green.shade200)
                      : Colors.grey.shade300,
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
                    size: 14,
                    color: isCompleted ? Colors.white : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statuses[index]['title'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.black87 : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, DeliveryState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(Icons.person, color: Colors.blueGrey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.driverName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text(
                  'Your Courier Driver',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: Color(0xFF10B981)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF3B82F6)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(String address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  address,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(height: 20),
          ...state.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x ${item.name}'),
                    Text('${(item.price * item.quantity).toStringAsFixed(2)} ETB'),
                  ],
                ),
              )),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee', style: TextStyle(color: Colors.grey)),
              Text('${state.deliveryFee.toStringAsFixed(2)} ETB'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '${state.totalPrice.toStringAsFixed(2)} ETB',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF10B981)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}