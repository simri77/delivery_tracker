import '../models/order_model.dart';

class ApiService {
  // Returns instant mock data so you can build your UI without a running backend
  static Future<OrderModel> fetchActiveOrder() async {
    // Simulate a brief network delay if you want, or return immediately
    await Future.delayed(const Duration(milliseconds: 300));

    return OrderModel(
      id: 1,
      orderIdString: 'ORD-8921',
      status: 'out_for_delivery',
      estimatedTime: '18 min ETA',
      driverName: 'Marcus Vance',
      deliveryAddress: 'Apt 4B, 742 Evergreen Terr',
      totalPrice: 42.50,
    );
  }
}