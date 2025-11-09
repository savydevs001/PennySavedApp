import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:penny/Components/Global/TextField.dart';

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

  List<String> selectedInvestments = ["Stocks", "Mutual Funds", "Index Funds"];
  List<String> availableInvestments = [
    "Stocks",
    "Mutual Funds",
    "Index Funds",
    "Bonds",
    "ETFs"
  ];
  String selectedRiskLevel = "Low Risk";

  @override
  Widget build(BuildContext context) {
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
                        _inputFields(),

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

                        // Risk Level Dropdown
                        const Text("Risk Level",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 8),

                        _riskLevelDropdown(),
                        _SubDessectionTitle(
                            "Low risk let penny saved invest only in mutual funds and safe investments."),
                        const SizedBox(height: 20),

                        // Save Button
                        _saveButton(),
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
  Widget _inputFields() {
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
                controller: lastNameController,
                hintText: "Email Address",
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
            children: selectedInvestments
                .map((investment) => Chip(
                      label: Text(investment,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: const Color.fromRGBO(128, 131, 144, 0.9),
                      deleteIcon: const Icon(Icons.close, color: Colors.white),
                      onDeleted: () {
                        setState(() {
                          selectedInvestments.remove(investment);
                        });
                      },
                    ))
                .toList(),
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

  // Risk Level Dropdown
  Widget _riskLevelDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(36, 36, 51, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
            width: 1,
          )),
      child: DropdownButton<String>(
        value: selectedRiskLevel,
        dropdownColor: const Color.fromRGBO(36, 36, 51, 1),
        style: const TextStyle(color: Colors.white),
        underline: Container(),
        isExpanded: true,
        items: ["Low Risk", "Medium Risk", "High Risk"]
            .map((risk) => DropdownMenuItem(
                  value: risk,
                  child:
                      Text(risk, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedRiskLevel = value!;
          });
        },
      ),
    );
  }

  // Save Button
  Widget _saveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(96, 98, 108, 1),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () {},
      child: const Center(
        child:
            Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
