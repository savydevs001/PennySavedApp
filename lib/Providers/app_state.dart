import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../Utils/api_config.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService(baseUrl: ApiConfig.baseUrl);

  // Example state variables
  String? _authToken;
  Map<String, dynamic>? _userProfile;

  // Getters
  String? get authToken => _authToken;
  Map<String, dynamic>? get userProfile => _userProfile;

  // Setters
  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  void setUserProfile(Map<String, dynamic> profile) {
    _userProfile = profile;
    notifyListeners();
  }

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    try {
      final response = await _apiService.get(ApiConfig.userProfile);
      setUserProfile(response);
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      final response = await _apiService.put(ApiConfig.updateUser, updatedData);
      setUserProfile(response);
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }
}