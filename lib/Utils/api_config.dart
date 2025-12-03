class ApiConfig {
  static const String baseUrl = 'https://api.pennysavedllc.co/api';

  // Define your endpoints here
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String userProfile = '/user/me';
  static const String updateUser = '/user/update';
  static const String fetchData = '/data';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
}