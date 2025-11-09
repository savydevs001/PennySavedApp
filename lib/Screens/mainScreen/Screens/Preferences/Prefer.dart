import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Screens/mainScreen/Notification/index.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String selectedLanguage = 'English';
  String selectedCurrency = 'USD';
  bool autoUpdate = true;

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
        padding: const EdgeInsets.all(18.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromRGBO(47, 43, 61, 1),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Preferences",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text("Language",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                _buildDropdown(
                    ['English', 'Spanish', 'French'], selectedLanguage,
                    (value) {
                  setState(() => selectedLanguage = value!);
                }),
                const SizedBox(height: 16),
                const Text("Preferred Currency",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                _buildDropdown(['USD', 'EUR', 'GBP'], selectedCurrency,
                    (value) {
                  setState(() => selectedCurrency = value!);
                }),
                const SizedBox(height: 24),
                const Divider(color: Color.fromARGB(54, 255, 255, 255)),
                _buildToggle(),
                const SizedBox(height: 24),
                const Divider(color: Color.fromARGB(54, 255, 255, 255)),
                _buildDeactivateButton(),
                const Divider(
                  color: Color.fromARGB(54, 255, 255, 255),
                ),
                const Spacer(),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
      ),
    );
  }

  Widget _buildDeactivateButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Account Deactivation",
            style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text("Account Deactivation",
            style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 4),
        const Text("You can deactivate your account anytime from here",
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(133, 187, 101, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: const Text("Deactivate",
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
