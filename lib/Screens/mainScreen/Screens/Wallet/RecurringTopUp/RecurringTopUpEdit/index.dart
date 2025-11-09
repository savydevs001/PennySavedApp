import 'package:flutter/material.dart';
import 'package:penny/Components/Global/Button.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/RecurringTopUp/Index.dart';

class RecurringTopUpEditScreen extends StatefulWidget {
  const RecurringTopUpEditScreen({super.key});

  @override
  _RecurringTopUpEditScreenState createState() =>
      _RecurringTopUpEditScreenState();
}

class _RecurringTopUpEditScreenState extends State<RecurringTopUpEditScreen> {
  bool isRecurring = false;
  String? selectedFrequency = "Monthly";
  TextEditingController amountController = TextEditingController(text: "\$500");
  TextEditingController startDateController =
      TextEditingController(text: "Dec 9, 2026");
  TextEditingController endDateController =
      TextEditingController(text: "Dec 9, 2026");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1), // Dark background
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(36, 36, 51, 1),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "Recurring Top Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Toggle Switch
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align items at the top
                    children: [
                      const Expanded(
                        child: Text(
                          "Would you like to make this a recurring contribution?",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                      Switch(
                        value: isRecurring,
                        onChanged: (value) {
                          setState(() {
                            isRecurring = value;
                          });
                        },
                        activeColor: const Color.fromRGBO(133, 187, 101, 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Funding Frequency & Amount
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedFrequency,
                          dropdownColor: Colors.black,
                          items: ["Daily", "Weekly", "Monthly", "Yearly"]
                              .map((freq) => DropdownMenuItem(
                                    value: freq,
                                    child: Text(freq,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFrequency = value;
                            });
                          },
                          decoration: _inputDecoration("Funding Frequency"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration("Amount"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Start Date
                  TextFormField(
                    controller: startDateController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _dateInputDecoration("Start Date (Optional)"),
                    onTap: () => _selectDate(context, startDateController),
                  ),
                  const SizedBox(height: 10),

                  // End Date
                  TextFormField(
                    controller: endDateController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _dateInputDecoration("End Date (Optional)"),
                    onTap: () => _selectDate(context, endDateController),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Color.fromRGBO(154, 146, 184, 0.52),
                  ),
                  const SizedBox(height: 345),
                  SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                          name: "Save Changes",
                          onPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecurringTopUp(),
                              ),
                            );
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Input Decoration for TextFields
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      filled: true,
      fillColor: const Color(0xFF1E2532),
    );
  }

  // Date Picker Decoration
  InputDecoration _dateInputDecoration(String label) {
    return _inputDecoration(label).copyWith(
      suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
    );
  }

  // Date Picker Function
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 12, 9),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // Dark Theme for Date Picker
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }
}
