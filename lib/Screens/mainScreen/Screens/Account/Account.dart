import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:penny/Components/Global/TextField.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/app_state.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Only these three options are allowed per spec
  List<String> availableInvestments = ["SPY", "QQQ", "GLD"];
  List<String> selectedInvestments = [];
  // Risk level removed per request
  bool _isDirty = false;
  bool _initialized = false;
  String? _currentCountryCode;
  String? _initialFullPhone;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1), // Dark Background

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                    color: Color.fromRGBO(133, 187, 101, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
              const Text(
                "Manage your personal information and account preferences.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(47, 43, 61, 0.8),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("Personal Information"),
                        _inputFields(appState),

                        const SizedBox(height: 20),

                        // Investment Preferences
                        _sectionTitle("Investment Preferences"),
                        _SubsectionTitle(
                            "Set up your preferred investment types and risk levels"),
                        const Text("Investment Types",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 8),
                        _investmentSelection(),
                        _SubDessectionTitle(
                          "Select the investment types you'd like Penny Saved to manage for you."),

                        const SizedBox(height: 20),

                        // Save Button
                        _saveButton(appState),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _SubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: Color.fromRGBO(128, 131, 144, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _SubDessectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8),
      child: Text(
        title,
        style: const TextStyle(
            color: Color.fromRGBO(128, 131, 144, 1),
            fontSize: 11,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  // Personal Information Inputs
  Widget _inputFields(AppState appState) {
    // initialize controllers once
    if (!_initialized) {
      firstNameController.text = appState.firstName;
      lastNameController.text = appState.lastName;
      emailController.text = appState.email;
      final norm = _normalizePhone(appState.userProfile?['phoneNumber']?.toString() ?? '');
      _initialFullPhone = norm;
      // if normalized has leading +, remove it for the text field because IntlPhoneField manages country code
      phoneController.text = (norm.startsWith('+')) ? norm.substring(1) : norm;
      // load investments from preferences if available
      try {
        final inv = appState.preferences['investmentType'];
        if (inv is List) selectedInvestments = inv.map((e) => e.toString()).where((s) => availableInvestments.contains(s)).toList();
      } catch (_) {}
      _initialized = true;
    }

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: const Text("First Name",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ),
                      CustomTextField(
                        controller: firstNameController,
                        hintText: 'First Name',
                        onChanged: (_) => _onChanged(),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: const Text("Last Name",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ),
                      CustomTextField(
                        controller: lastNameController,
                        hintText: "Last Name",
                        onChanged: (_) => _onChanged(),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: const Text("Email Address",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
              ),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email Address",
                  onChanged: (_) => _onChanged(),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Phone Number Input
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: IntlPhoneField(
              controller: phoneController,
              decoration: const InputDecoration(
                  labelText: "Phone Number",
                  filled: true,
                  fillColor: Color.fromRGBO(36, 36, 51, 1),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(254, 255, 255, 1),
                        style: BorderStyle.solid,
                        width: 1),
                  )),
              initialCountryCode: 'US',
              style: const TextStyle(color: Colors.white),
              dropdownTextStyle: const TextStyle(color: Colors.white),
              onChanged: (v) {
                // keep the selected country code (e.g. +1) and set controller to national number
                _currentCountryCode = v.countryCode;
                phoneController.text = v.number ?? '';
                _onChanged();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Investment Selection
  Widget _investmentSelection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 1,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            children: availableInvestments.map((investment) {
              final selected = selectedInvestments.contains(investment);
              return FilterChip(
                label: Text(investment, style: const TextStyle(color: Colors.white)),
                selected: selected,
                selectedColor: const Color.fromRGBO(133, 187, 101, 1),
                checkmarkColor: Colors.black,
                backgroundColor: const Color.fromRGBO(47, 43, 61, 0.6),
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      if (!selectedInvestments.contains(investment)) selectedInvestments.add(investment);
                    } else {
                      selectedInvestments.remove(investment);
                    }
                    _onChanged();
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Select investment types",
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(133, 187, 101, 1)),
                child: IconButton(
                  onPressed: () => _showInvestmentDialog(),
                  icon: const Icon(Icons.add,
                      color: Color.fromRGBO(47, 43, 61, 1)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Investment Selection Dialog
  void _showInvestmentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2532),
          title: const Text("Add Investment Type",
              style: TextStyle(color: Colors.white)),
          content: Wrap(
            children: availableInvestments.map((investment) {
              return ListTile(
                title: Text(investment,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  if (!selectedInvestments.contains(investment)) {
                    setState(() {
                      selectedInvestments.add(investment);
                    });
                  }
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // risk level removed — no widget

  String _normalizePhone(String raw) {
    if (raw == null) return '';
    String s = raw.toString();
    // keep leading + if present, remove everything else except digits
    final hasPlus = s.contains('+');
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    // limit to max 15 digits (E.164 max length without +)
    String trimmed = digits;
    if (trimmed.length > 15) trimmed = trimmed.substring(trimmed.length - 15);
    if (trimmed.isEmpty) return '';
    return hasPlus ? '+$trimmed' : '+$trimmed';
  }

  // Save Button
  Widget _saveButton(AppState appState) {
    final canSave = _isDirty && selectedInvestments.isNotEmpty;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: canSave ? const Color.fromRGBO(133, 187, 101, 1) : const Color.fromRGBO(96, 98, 108, 1),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: canSave
          ? () async {
              final payload = {
                'firstName': firstNameController.text.trim(),
                'lastName': lastNameController.text.trim(),
                'email': emailController.text.trim(),
                'phoneNumber': phoneController.text.trim(),
                'preferences': {'investmentType': selectedInvestments}
              };
              try {
                await appState.updateUserProfile(payload);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
                setState(() {
                  _isDirty = false;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
              }
            }
          : null,
      child: Center(
        child: Text("Save", style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  void _onChanged() {
    // mark dirty whenever a field differs from AppState values (simple heuristic)
    setState(() {
      _isDirty = true;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
