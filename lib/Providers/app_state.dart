import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../Services/auth_service.dart';
import '../Utils/api_config.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService(baseUrl: ApiConfig.baseUrl);

  // Example state variables
  String? _authToken;
  Map<String, dynamic>? _userProfile;
  bool _isLoadingProfile = false;

  // Typed profile fields with sensible defaults
  Map<String, dynamic> _preferences = {'investmentType': []};
  String _id = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String? _googleId;
  String? _stripeAccountId;
  String? _resetOTP;
  DateTime? _resetOTPExpires;
  bool _twoFactorEnabled = false;
  String? _twoFactorOTP;
  DateTime? _twoFactorOTPExpires;
  num _walletBalance = 0;
  bool _roundUpEnabled = false;
  String _roundUpFrequency = 'daily';
  DateTime? _lastRoundUpDate;
  DateTime? _nextRoundUpDate;
  int _roundUpMultiplier = 1;
  String? _stripeCustomerId;
  String? _quilttUserId;
  DateTime? _quilttSessionExpiry;
  DateTime? _createdAt;
  DateTime? _updatedAt;
  int _v = 0;

//also add these market stats: totalInvestment=41 (int),portfolioValue=40.87 (double),profitLoss=-0.13 (double),percentChange=-0.32 (double)
  int _totalInvestment = 0;
  double _portfolioValue = 0.0;
  double _profitLoss = 0.0;
  double _percentChange = 0.0;

  // Getters
  String? get authToken => _authToken;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoadingProfile => _isLoadingProfile;


  // Typed getters
  Map<String, dynamic> get preferences => _preferences;
  String get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String? get googleId => _googleId;
  String? get stripeAccountId => _stripeAccountId;
  String? get resetOTP => _resetOTP;
  DateTime? get resetOTPExpires => _resetOTPExpires;
  bool get twoFactorEnabled => _twoFactorEnabled;
  String? get twoFactorOTP => _twoFactorOTP;
  DateTime? get twoFactorOTPExpires => _twoFactorOTPExpires;
  num get walletBalance => _walletBalance;
  bool get roundUpEnabled => _roundUpEnabled;
  String get roundUpFrequency => _roundUpFrequency;
  DateTime? get lastRoundUpDate => _lastRoundUpDate;
  DateTime? get nextRoundUpDate => _nextRoundUpDate;
  int get roundUpMultiplier => _roundUpMultiplier;
  String? get stripeCustomerId => _stripeCustomerId;
  String? get quilttUserId => _quilttUserId;
  DateTime? get quilttSessionExpiry => _quilttSessionExpiry;
  DateTime? get createdAt => _createdAt;
  DateTime? get updatedAt => _updatedAt;
  int get v => _v;
  int get totalInvestment => _totalInvestment;
  double get portfolioValue => _portfolioValue;
  double get profitLoss => _profitLoss;
  double get percentChange => _percentChange;
  bool get isProfit => _profitLoss > 0;

  // Setters
  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  void setTotalInvestment(int value) {
    _totalInvestment = value;
    notifyListeners();
  }
  void setPortfolioValue(double value) {
    _portfolioValue = value;
    notifyListeners();
  }
  void setProfitLoss(double value) {
    _profitLoss = value;
    notifyListeners();
  }
  void setPercentChange(double value) {
    _percentChange = value;
    notifyListeners();
  }

  
  // Set user profile and populate typed fields

  void setUserProfile(Map<String, dynamic>? profile) {
    _userProfile = profile;
    // populate typed fields with defaults when missing
    if (profile == null) {
      _preferences = {'investmentType': []};
      _id = '';
      _firstName = '';
      _lastName = '';
      _email = '';
      _googleId = null;
      _stripeAccountId = null;
      _resetOTP = null;
      _resetOTPExpires = null;
      _twoFactorEnabled = false;
      _twoFactorOTP = null;
      _twoFactorOTPExpires = null;
      _walletBalance = 0;
      _roundUpEnabled = false;
      _roundUpFrequency = 'daily';
      _lastRoundUpDate = null;
      _nextRoundUpDate = null;
      _roundUpMultiplier = 1;
      _stripeCustomerId = null;
      _quilttUserId = null;
      _quilttSessionExpiry = null;
      _createdAt = null;
      _updatedAt = null;
      _v = 0;
      notifyListeners();
      return;
    }

    // helper to parse dates
    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    _preferences = (profile['preferences'] is Map) ? Map<String, dynamic>.from(profile['preferences']) : {'investmentType': []};
    _id = profile['_id']?.toString() ?? profile['id']?.toString() ?? '';
    _firstName = profile['firstName']?.toString() ?? '';
    _lastName = profile['lastName']?.toString() ?? '';
    _email = profile['email']?.toString() ?? '';
    _googleId = profile['googleId']?.toString();
    _stripeAccountId = profile['stripeAccountId']?.toString();
    _resetOTP = profile['resetOTP']?.toString();
    _resetOTPExpires = _parseDate(profile['resetOTPExpires']);
    _twoFactorEnabled = profile['twoFactorEnabled'] == true;
    _twoFactorOTP = profile['twoFactorOTP']?.toString();
    _twoFactorOTPExpires = _parseDate(profile['twoFactorOTPExpires']);
    _walletBalance = (profile['walletBalance'] is num) ? profile['walletBalance'] : (num.tryParse(profile['walletBalance']?.toString() ?? '') ?? 0);
    _roundUpEnabled = profile['roundUpEnabled'] == true;
    _roundUpFrequency = profile['roundUpFrequency']?.toString() ?? 'daily';
    _lastRoundUpDate = _parseDate(profile['lastRoundUpDate']);
    _nextRoundUpDate = _parseDate(profile['nextRoundUpDate']);
    _roundUpMultiplier = (profile['roundUpMultiplier'] is int) ? profile['roundUpMultiplier'] : (int.tryParse(profile['roundUpMultiplier']?.toString() ?? '') ?? 1);
    _stripeCustomerId = profile['stripeCustomerId']?.toString();
    _quilttUserId = profile['quilttUserId']?.toString();
    _quilttSessionExpiry = _parseDate(profile['quilttSessionExpiry']);
    _createdAt = _parseDate(profile['createdAt']);
    _updatedAt = _parseDate(profile['updatedAt']);
    _v = (profile['__v'] is int) ? profile['__v'] : (int.tryParse(profile['__v']?.toString() ?? '') ?? 0);

    notifyListeners();
  }

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    _isLoadingProfile = true;
    notifyListeners();
    try {
      final token = await AuthService().getToken();
      Map<String, String>? headers;
      if (token != null) {
        headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
      } else {
        headers = {'Content-Type': 'application/json'};
      }

      final response = await _apiService.get(ApiConfig.userProfile, headers: headers);

      // log raw response
      print('fetchUserProfile response: $response');

      // backend may return { success: true, user: { ... } }
      if (response is Map && response.containsKey('user')) {
        // log received fields
        print('Received user keys: ${ (response['user'] as Map).keys.toList() }');
        setUserProfile(response['user']);
      } else {
        print('Received keys: ${ response is Map ? response.keys.toList() : 'not a map' }');
        setUserProfile(response as Map<String, dynamic>?);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    _isLoadingProfile = true;
    notifyListeners();
    try {
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final response = await _apiService.put(ApiConfig.userProfile, updatedData, headers: headers);

      // backend may return { success: true, user: { ... } }
      if (response is Map && response.containsKey('user')) {
        setUserProfile(response['user']);
      } else {
        setUserProfile(response as Map<String, dynamic>?);
      }
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }
}