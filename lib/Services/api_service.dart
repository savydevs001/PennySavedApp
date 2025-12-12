import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  /// Optional token provider callback. Set by AuthService to automatically add Authorization header.
  static Future<String?> Function()? tokenProvider;

  ApiService({required this.baseUrl});

  Future<Map<String, String>> _buildHeaders(Map<String, String>? headers) async {
    final Map<String, String> h = headers != null ? Map.from(headers) : {'Content-Type': 'application/json'};
    if (!h.containsKey('Authorization') && tokenProvider != null) {
      try {
        final token = await tokenProvider!();
        if (token != null && token.isNotEmpty) {
          h['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        // ignore token provider failure; continue without Authorization header
      }
    }
    return h;
  }

  // GET Request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: builtHeaders);
      _debugResponse(response);
      return _handleResponse(response);
    } catch (e) {
      print('GET request error: $e');
      rethrow;
    }
  }

  // POST Request
  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: builtHeaders,
        body: jsonEncode(body),
      );
      _debugResponse(response);
      return _handleResponse(response);
    } catch (e) {
      print('POST request error: $e');
      rethrow;
    }
  }

  // PUT Request
  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: builtHeaders,
        body: jsonEncode(body),
      );
      _debugResponse(response);
      return _handleResponse(response);
    } catch (e) {
      print('PUT request error: $e');
      rethrow;
    }
  }

  // DELETE Request
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: builtHeaders);
      _debugResponse(response);
      return _handleResponse(response);
    } catch (e) {
      print('DELETE request error: $e');
      rethrow;
    }
  }

  // Debugging Helper
  void _debugResponse(http.Response response) {
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  // Response Handler
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }
}