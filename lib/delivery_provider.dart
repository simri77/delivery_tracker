import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Delivery status pipeline enum
enum DeliveryStatus {
  placed,
  preparing,
  outForDelivery,
  delivered,
}

// 2. Model for an individual order item
class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// 3. Immutable state container holding all order details
class DeliveryState {
  final String orderId;
  final DeliveryStatus status;
  final String driverName;
  final String driverPhone;
  final String estimatedTime;
  final String deliveryAddress;
  final List<OrderItem> items;
  final double deliveryFee;

  DeliveryState({
    required this.orderId,
    required this.status,
    required this.driverName,
    required this.driverPhone,
    required this.estimatedTime,
    required this.deliveryAddress,
    required this.items,
    required this.deliveryFee,
  });

  // Computed getters for totals
  double get subtotal => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get totalPrice => subtotal + deliveryFee;

  // Immutable copyWith method to safely update state fields
  DeliveryState copyWith({
    DeliveryStatus? status,
    String? estimatedTime,
  }) {
    return DeliveryState(
      orderId: orderId,
      status: status ?? this.status,
      driverName: driverName,
      driverPhone: driverPhone,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      deliveryAddress: deliveryAddress,
      items: items,
      deliveryFee: deliveryFee,
    );
  }
}


// 4. StateNotifier to handle order updates and business logic
class DeliveryNotifier extends StateNotifier<DeliveryState> {
  DeliveryNotifier()
      : super(
          DeliveryState(
            orderId: '#ORD-89421',
            status: DeliveryStatus.outForDelivery,
            driverName: 'Abebe Kebede',
            driverPhone: '+251911223344',
            estimatedTime: '15 - 20 mins',
            deliveryAddress: 'Kebele 04, Adama, Ethiopia',
            items: [
              OrderItem(name: 'Double Cheese Burger', quantity: 2, price: 350.0),
              OrderItem(name: 'Crispy French Fries', quantity: 1, price: 150.0),
              OrderItem(name: 'Fresh Mango Juice', quantity: 2, price: 120.0),
            ],
            deliveryFee: 100.0,
          ),
        );

  // Action to progress delivery state through the pipeline
  void advanceStatus() {
    switch (state.status) {
      case DeliveryStatus.placed:
        state = state.copyWith(status: DeliveryStatus.preparing, estimatedTime: '30 - 35 mins');
        break;
      case DeliveryStatus.preparing:
        state = state.copyWith(status: DeliveryStatus.outForDelivery, estimatedTime: '15 - 20 mins');
        break;
      case DeliveryStatus.outForDelivery:
        state = state.copyWith(status: DeliveryStatus.delivered, estimatedTime: 'Arrived');
        break;
      case DeliveryStatus.delivered:
        // Loop back to initial state for demo preview purposes
        state = state.copyWith(status: DeliveryStatus.placed, estimatedTime: '40 - 45 mins');
        break;
    }
  }
}

// 5. Expose the notifier globally via StateNotifierProvider
final deliveryProvider = StateNotifierProvider<DeliveryNotifier, DeliveryState>((ref) {
  return DeliveryNotifier();
});