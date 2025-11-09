import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Utils/api_config.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  // Save token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Remove token
  Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Login
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await saveToken(token);
        return token;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await removeToken();
  }

  // Check authentication status
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}