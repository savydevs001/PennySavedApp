class ApiConfig {
  static const String baseUrl = 'https://api.pennysavedllc.co/api';

  // Define your endpoints here
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String userProfile = '/auth/user/profile';
  static const String updateUser = '/user/update';
  static const String fetchData = '/data';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String verifyLoginOtp = '/auth/verify-login-otp';
  static const String updatePassword = '/auth/update-password';
  static const String marketStats = '/market/stats';
  static const String marketInvest = '/market/invest';
  static const String marketWithdraw = '/market/withdraw';
  static const String enable2faSend = '/auth/enable-2fa/send-otp';
  static const String disable2faSend = '/auth/disable-2fa/send-otp';
  static const String enable2faVerify = '/auth/enable-2fa/verify-otp';
  static const String disable2faVerify = '/auth/disable-2fa/verify-otp';
  static const String contact = '/auth/contact';
}