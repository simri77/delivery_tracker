import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  // Create secure storage instance with encrypted options enabled
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _tokenKey = 'jwt_token';

  // Save Token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Retrieve Token securely
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete Token (Logout)
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}