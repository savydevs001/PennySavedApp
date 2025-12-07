import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Components/Global/TextField.dart';
import 'package:penny/Screens/mainScreen/Notification/index.dart';
import 'package:penny/Screens/mainScreen/Screens/Enable2FA/Enable2FAPhone/2FAPhone.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/app_state.dart';
import '../../../../Services/api_service.dart';
import '../../../../Utils/api_config.dart';
import '../../../../Services/auth_service.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  String selectedLanguage = 'English';
  String selectedCurrency = 'USD';
  bool autoUpdate = true;
  bool isVisible = false;
  bool isVisibleforConfirm = false;
  bool isPhoneSelected = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _canSave = false;
  void setVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void setVisibilityForConfirm() {
    setState(() {
      isVisibleforConfirm = !isVisibleforConfirm;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Your password doesn't match the first one you entered";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Your password doesn't match the first one you entered";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/appbar/Back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
        elevation: 0,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/appbar/Notifications.svg',
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(47, 43, 61, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            // Make it scrollable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Profile Security",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text("Current Password",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: currentPasswordController,
                  hintText: "Current Password",
                  isPassword: isVisible,
                  labelText: 'Current Password',
                  onChanged: (_) => _updateCanSave(),
                  suffixIcon: IconButton(
                    icon: Icon(isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: setVisibility,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("New Password",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: newPasswordController,
                  hintText: "New Password",
                  isPassword: isVisible,
                  labelText: 'New Password',
                  onChanged: (_) => _updateCanSave(),
                  suffixIcon: IconButton(
                    icon: Icon(isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: setVisibility,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("New Password Confirmation",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: "New Password Confirmation",
                  isPassword: isVisibleforConfirm,
                  labelText: 'New Password Confirmation',
                  validator: _validatePassword,
                  onChanged: (_) => _updateCanSave(),
                  suffixIcon: IconButton(
                    icon: Icon(isVisibleforConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: setVisibilityForConfirm,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color.fromARGB(54, 255, 255, 255)),
                _buildDeactivateButton(),
                const Divider(color: Color.fromARGB(54, 255, 255, 255)),
                const SizedBox(
                  height: 80,
                ),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeactivateButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Two-Factor Authentication",
            style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text("Add an extra layer of security to your account.",
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final appState = Provider.of<AppState>(context, listen: false);
            final isEnabled = appState.twoFactorEnabled;
            await _send2faOtp(isEnabled);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(133, 187, 101, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: Consumer<AppState>(builder: (context, appState, _) {
            final enabled = appState.twoFactorEnabled;
            return Text(enabled ? "Disable 2FA" : "Enable 2FA",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14));
          }),
        ),
      ],
    );
  }

  Future<void> _send2faOtp(bool currentlyEnabled) async {
    final api = ApiService(baseUrl: ApiConfig.baseUrl);
    final token = await AuthService().getToken();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';

    final endpoint = currentlyEnabled ? ApiConfig.disable2faSend : ApiConfig.enable2faSend;
    try {
      final resp = await api.post(endpoint, {}, headers: headers);
      if (resp is Map && resp['success'] == true && resp['message'] != null && resp['message'].toString().toLowerCase().contains('otp sent')) {
        // show OTP entry dialog
        _showOtpDialog(currentlyEnabled);
      } else {
        final msg = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Failed to send OTP';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Send OTP failed: $e')));
    }
  }

  void _showOtpDialog(bool currentlyEnabled) {
    String otp = '';
    int seconds = 60;
    Timer? timer;

    void startTimer(StateSetter setState) {
      timer?.cancel();
      seconds = 60;
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() {
          seconds -= 1;
          if (seconds <= 0) {
            timer?.cancel();
          }
        });
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          // start the countdown once using the dialog's setState so UI updates
          bool _started = false;
          if (!_started) {
            _started = true;
            startTimer(setState);
          }
          return AlertDialog(
            backgroundColor: const Color.fromRGBO(36, 36, 51, 1),
            title: Text(currentlyEnabled ? 'Disable 2FA — enter OTP' : 'Enable 2FA — enter OTP', style: const TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter the 6-digit OTP', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(counterText: ''),
                  onChanged: (v) {
                    setState(() {
                      otp = v.trim();
                    });
                  },
                ),
                const SizedBox(height: 8),
                seconds > 0
                    ? Text('Resend in ${seconds}s', style: const TextStyle(color: Colors.white54))
                    : TextButton(
                        onPressed: () async {
                          // resend
                          setState(() {
                            seconds = 60;
                          });
                          startTimer(setState);
                          await _send2faOtp(currentlyEnabled);
                        },
                        child: const Text('Resend', style: TextStyle(color: Colors.white)),
                      )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  timer?.cancel();
                  Navigator.pop(context);
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                onPressed: otp.length == 6
                    ? () async {
                        timer?.cancel();
                        Navigator.pop(context);
                        await _verify2faOtp(currentlyEnabled, otp);
                      }
                    : null,
                child: const Text('Verify'),
              ),
            ],
          );
        });
      },
    ).then((_) {
      // ensure timer is cancelled when dialog closes
      try {
        // timer is in outer scope; cancel if active
        timer?.cancel();
      } catch (_) {}
    });
  }

  Future<void> _verify2faOtp(bool currentlyEnabled, String otp) async {
    final api = ApiService(baseUrl: ApiConfig.baseUrl);
    final token = await AuthService().getToken();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    final endpoint = currentlyEnabled ? ApiConfig.disable2faVerify : ApiConfig.enable2faVerify;
    try {
      final resp = await api.post(endpoint, {'otp': otp}, headers: headers);
      final msg = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Verification failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      if (resp is Map && resp['success'] == true) {
        // refresh profile
        final appState = Provider.of<AppState>(context, listen: false);
        await appState.fetchUserProfile();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification error: $e')));
    }
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _canSave ? const Color.fromRGBO(133, 187, 101, 1) : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: _canSave
            ? () async {
                await _updatePassword();
              }
            : null,
        child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  void _updateCanSave() {
    final cur = currentPasswordController.text.trim();
    final neo = newPasswordController.text.trim();
    final conf = confirmPasswordController.text.trim();
    final can = cur.isNotEmpty && neo.isNotEmpty && conf.isNotEmpty;
    if (can != _canSave) {
      setState(() {
        _canSave = can;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final current = currentPasswordController.text.trim();
    final neo = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();
    if (current.isEmpty || neo.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all password fields')));
      return;
    }
    if (neo != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New password and confirmation do not match')));
      return;
    }

    try {
      final token = await AuthService().getToken();
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final body = {'currentPassword': current, 'newPassword': neo};
      final response = await api.put(ApiConfig.updatePassword, body, headers: headers);
      String message = 'Password update response';
      if (response is Map && response['message'] != null) message = response['message'].toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      // clear fields on success
      if (response is Map && (response['message']?.toString().toLowerCase().contains('success') ?? false)) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password update failed: $e')));
    }
  }
}
