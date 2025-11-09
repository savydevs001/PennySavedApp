import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:penny/Screens/mainScreen/Screens/ContactSupport/ContactSupport.dart';
import 'package:penny/Screens/mainScreen/Screens/Enable2FA/Enable2FA.dart';
import 'package:penny/Screens/mainScreen/Screens/Preferences/Prefer.dart';
import 'package:penny/Screens/mainScreen/Screens/Terms&Conditions/Index.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/PaymentMethods/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Text(
              "Settings",
              style: TextStyle(
                color: Color.fromRGBO(133, 187, 101, 1), // Green title
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Customize your experience and manage your account.",
              style: TextStyle(
                color: Colors.white70, // Light gray text
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Settings List
            _buildSettingsOption(
              SvgPicture.asset('assets/icons/Settings/ProfileSecurity.svg'),
              "Profile Security",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SecurityScreen()),
                );
              },
            ),
            _buildSettingsOption(
              SvgPicture.asset('assets/icons/Settings/Prefer.svg'),
              "Preferences",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PreferencesScreen()),
                );
              },
            ),
            _buildSettingsOption(
              SvgPicture.asset('assets/icons/Settings/Payment.svg'),
              "Payment Methods",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentMethodScreen()),
                );
              },
            ),
            _buildSettingsOption(
              SvgPicture.asset('assets/icons/Settings/Contact.svg'),
              "Contact Support",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactSupportScreen()),
                );
              },
            ),
            _buildSettingsOption(
              SvgPicture.asset('assets/icons/Settings/T&C.svg'),
              "Terms and conditions",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditionsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to create settings options
  Widget _buildSettingsOption(Widget icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            icon, // Icon
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
