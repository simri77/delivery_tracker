import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class ApiService {
  // Use 'http://10.0.2.2:5000' if using Android Emulator, or 'http://localhost:5000' for Linux desktop
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<OrderModel> fetchActiveOrder() async {
    final response = await http.get(Uri.parse('$baseUrl/orders/active'));

    if (response.statusCode == 200) {
      return OrderModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load active order from backend');
    }
  }
}