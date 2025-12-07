import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Utils/api_config.dart';
import 'api_service.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService(baseUrl: ApiConfig.baseUrl);
  final StreamController<String?> _tokenController = StreamController<String?>.broadcast();

  Stream<String?> get tokenStream => _tokenController.stream;

  // Save token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    try {
      _tokenController.add(token);
    } catch (_) {}
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Remove token
  Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
    try {
      _tokenController.add(null);
    } catch (_) {}
  }

  // Login
  /// Attempts to login and returns a structured result map.
  /// Result keys: `success` (bool), `twoFactorRequired` (bool), `statusCode` (int), `message` (String), `user` (Map?)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final status = response.statusCode;
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (status == 200) {
        // Check if backend requires two-factor authentication
        final twoFactor = body is Map && body['twoFactorRequired'] == true;
        // detect token if backend returned one
        String? token;
        if (body is Map) {
          token = body['token']?.toString() ?? body['accessToken']?.toString() ?? body['access_token']?.toString();
        }
        if (token != null) await saveToken(token);
        return {
          'success': !twoFactor,
          'twoFactorRequired': twoFactor,
          'statusCode': status,
          'message': body['message'] ?? 'Login successful',
          'user': body['user'],
          'token': token,
        };
      }

      // For 401 / 404 and other client errors, return structured info
      return {
        'success': false,
        'twoFactorRequired': false,
        'statusCode': status,
        'message': body is Map ? (body['message'] ?? 'Error') : 'Error',
      };
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'twoFactorRequired': false,
        'statusCode': 500,
        'message': 'Network or server error',
      };
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

  // Sign Up
  Future<String?> signUp(String firstName, String lastName, String email, String password) async {
    try {
      final response = await _apiService.post(ApiConfig.register, {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      });

      if (response != null && response['token'] != null) {
        final token = response['token'];
        await saveToken(token);
        return token;
      } else {
        throw Exception('Sign-up failed: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Sign-up error: $e');
      return null;
    }
  }

  // Send OTP (generic) - returns true if backend accepted request
  Future<bool> sendOtp(String email, {String purpose = 'login'}) async {
    try {
      final response = await _apiService.post(ApiConfig.sendOtp, {
        'email': email,
        'purpose': purpose,
      });
      return response != null;
    } catch (e) {
      print('sendOtp error: $e');
      return false;
    }
  }

  // Verify OTP - returns true if OTP valid
  Future<bool> verifyOtp(String email, String code, {String purpose = 'login'}) async {
    try {
      final response = await _apiService.post(ApiConfig.verifyOtp, {
        'email': email,
        'code': code,
        'purpose': purpose,
      });
      if (response is Map && (response['valid'] == true || response['success'] == true)) {
        return true;
      }
      return false;
    } catch (e) {
      print('verifyOtp error: $e');
      return false;
    }
  }
}