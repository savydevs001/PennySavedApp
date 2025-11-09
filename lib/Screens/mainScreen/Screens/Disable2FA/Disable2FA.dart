import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:penny/Components/Global/TextField.dart';
import 'package:penny/Screens/mainScreen/Screens/Disable2FA/Disable2FAPhone/Disable2FAPhone.dart';

class SecurityDisableScreen extends StatefulWidget {
  const SecurityDisableScreen({super.key});

  @override
  _SecurityDisableScreenState createState() => _SecurityDisableScreenState();
}

class _SecurityDisableScreenState extends State<SecurityDisableScreen> {
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

  bool allow = true;
  var counterdecreasing;
  String countdown = "59";

  void secondcounter() {
    allow = false;
    counterdecreasing = 59;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown = counterdecreasing.toString();
      });
      counterdecreasing--;
      if (counterdecreasing <= -1) {
        setState(() {
          allow = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
        iconTheme: const IconThemeData(color: Colors.white),
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

  Widget _buildDropdown(List<String> items, String selectedItem,
      ValueChanged<String?> onChanged) {
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          dropdownColor: const Color(0xFF1E1E2E),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Update Features",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: 8),
            Text("Auto Update",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w400)),
            SizedBox(height: 4),
            Text("Add an extra layer of security to your account.",
                style: TextStyle(color: Colors.white70)),
          ],
        ),
        Switch(
          value: autoUpdate,
          activeColor: Colors.greenAccent,
          onChanged: (value) => setState(() => autoUpdate = value),
        ),
      ],
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
            Disable2FAPhoneDialog.showDisable2FAPhoneDialog(
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
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(243, 0, 0, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: const Text("Disable 2FA",
              style: TextStyle(
                  color: Colors.white,
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
