import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/AddFunds/ConfirmFund/ConfirmFund.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  _AddFundsScreenState createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  bool isRecurring = false;
  String? selectedFrequency = "Monthly";
  TextEditingController amountController = TextEditingController(text: "\$500");
  TextEditingController startDateController =
      TextEditingController(text: "Dec 9, 2026");
  TextEditingController endDateController =
      TextEditingController(text: "Dec 9, 2026");

  String selectedPaymentMethod = "****1234 Debit Card";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1), // Dark background
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(47, 43, 61, 0.8),
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add Funds to Wallet",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Amount Input
                  TextField(
                    controller: amountController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E1E26),
                      labelText: "Amount",
                      labelStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text("MAX",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Info Text
                  Row(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.info_outline,
                            color: Colors.white60, size: 16),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF1A1C2E),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Maximum Withdrawal Available",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Your fund is divided into 3 sections, total balance, available balance and pending balance.",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        buildBalanceRow(
                                            "Total Balance : \$22,859",
                                            "Your total funds, including available and pending amounts.",
                                            Colors.white),
                                        buildBalanceRow(
                                            "Available Balance : \$21,459  ",
                                            "Funds available for immediate investment or withdrawal.",
                                            Colors.white70),
                                        buildBalanceRow(
                                            "Pending Balance : \$1,459 ",
                                            "Funds from recent deposits or transactions awaiting clearance.",
                                            Colors.white70),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF84C67F),
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            "Close",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text("Maximum withdrawal available is: \$2,450",
                          style:
                              TextStyle(color: Colors.white60, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment Method
                  const Text("Payment Method",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: selectedPaymentMethod,
                    dropdownColor: const Color(0xFF1E1E26),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E1E26),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white),
                    style: const TextStyle(color: Colors.white),
                    items: [
                      "****1234 Debit Card",
                      "****1234 Bank Account",
                    ]
                        .map((method) => DropdownMenuItem<String>(
                              value: method,
                              child: Text(method),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  // Add New Payment Method
                  GestureDetector(
                    onTap: () {}, // Handle action
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.amber, size: 18),
                        SizedBox(width: 5),
                        Text("Add New Payment Method",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
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
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align items at the top
                          children: [
                            const Expanded(
                              child: Text(
                                "Would you like to make this a recurring contribution?",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ),
                            Switch(
                              value: isRecurring,
                              onChanged: (value) {
                                setState(() {
                                  isRecurring = value;
                                });
                              },
                              activeColor:
                                  const Color.fromRGBO(133, 187, 101, 1),
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
                                decoration:
                                    _inputDecoration("Funding Frequency"),
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
                          decoration:
                              _dateInputDecoration("Start Date (Optional)"),
                          onTap: () =>
                              _selectDate(context, startDateController),
                        ),
                        const SizedBox(height: 10),

                        // End Date
                        TextFormField(
                          controller: endDateController,
                          readOnly: true,
                          style: const TextStyle(color: Colors.white),
                          decoration:
                              _dateInputDecoration("End Date (Optional)"),
                          onTap: () => _selectDate(context, endDateController),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          color: Color.fromRGBO(154, 146, 184, 0.52),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Withdrawal Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Deposite Details",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text(
                            "You're about to confirm your withdrawal, please review data below.",
                            style:
                                TextStyle(color: Colors.white60, fontSize: 14)),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                            "Payment Method", selectedPaymentMethod),
                        _buildDetailRow("Withdrawal Amount", "\$2,450"),
                        _buildDetailRow("Fees", "\$2"),
                        _buildDetailRow("Total Amount", "\$2,448"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Withdraw Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FundConfirmScreen()),
                        );
                      }, // Handle withdrawal
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(133, 187, 101, 1),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text("Deposite",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 13)),
        ],
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

Widget buildBalanceRow(String title, String amount, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
