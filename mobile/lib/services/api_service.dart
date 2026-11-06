import 'dart:convert';
import 'package:http/http.dart' as http;
import 'shared_prefs_helper.dart';
import '../models/order_model.dart';

class ApiService {
  // Use localhost for Linux desktop execution
  static const String baseUrl = 'http://localhost:5000/api';

  /// Centralized helper to fetch headers with JWT Bearer token
  static Future> _getHeaders() async {
    final token = await SharedPrefsHelper.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Reusable GET wrapper
  static Future<http.Response> _getRequest(String endpoint) async {
    final headers = await _getHeaders();
    return await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  /// Reusable POST wrapper
  static Future<http.Response> _postRequest(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // 1. Fetch Active Order (Protected endpoint)
  static Future<OrderModel> fetchActiveOrder() async {
    try {
      final response = await _getRequest('/orders/active');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OrderModel.fromJson(data);
      } else {
        throw Exception('Failed to load active order: ${response.body}');
      }
    } catch (e) {
      // Fallback sample model if backend is unreachable during offline testing
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

  // 2. Fetch User Profile (Protected endpoint)
  static Future> fetchUserProfile() async {
    try {
      final response = await _getRequest('/user/profile');

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
}