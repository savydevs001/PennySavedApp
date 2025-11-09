import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Components/Global/TextField.dart';
import 'package:penny/Screens/mainScreen/Notification/index.dart';
import 'package:penny/Screens/mainScreen/Screens/Enable2FA/Enable2FAPhone/2FAPhone.dart';

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
                  hintText: "Current Password",
                  isPassword: isVisible,
                  labelText: 'Current Password',
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
                  hintText: "New Password",
                  isPassword: isVisible,
                  labelText: 'New Password',
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
                  hintText: "New Password Confirmation",
                  isPassword: isVisibleforConfirm,
                  labelText: 'New Password Confirmation',
                  validator: _validatePassword,
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
          onPressed: () {
            ConfirmationDialog.showConfirmationDialog(
              context: context,
              isPhoneSelected: isPhoneSelected,
              onToggle: (bool value) {
                setState(() {
                  isPhoneSelected = value;
                });
              },
              emailController: emailController,
              phoneController: phoneController,
            );

            // Handle withdrawal
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(133, 187, 101, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: const Text("Enable 2FA",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () {},
        child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
