import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Providers/app_state.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/AddFunds/ConfirmFund/ConfirmFund.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:penny/Services/api_service.dart';
import 'package:penny/Utils/api_config.dart';
import 'package:penny/Services/auth_service.dart';

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

  // Payment methods fetched from API
  List<Map<String, dynamic>> paymentMethods = [];
  bool _loadingMethods = true;
  String? selectedPaymentMethodId;
  bool _depositing = false;
  String selectedPaymentMethod = "****1234 Debit Card";

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
  }

  Future<void> _fetchPaymentMethods() async {
    setState(() {
      _loadingMethods = true;
    });
    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final resp = await api.get('/payment/saved-methods', headers: headers);
      if (resp is Map && resp['success'] == true && resp['paymentMethods'] is List) {
        final list = (resp['paymentMethods'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
        setState(() {
          paymentMethods = list;
          if (paymentMethods.isNotEmpty && selectedPaymentMethodId == null) {
            selectedPaymentMethodId = (paymentMethods.first['stripePaymentMethodId']?.toString() ?? paymentMethods.first['_id']?.toString() ?? paymentMethods.first['id']?.toString());
          }
        });
      }
    } catch (e) {
      print('Error fetching payment methods: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingMethods = false;
        });
      }
    }
  }

  Future<void> _submitDeposit() async {
    if (_depositing) return;
    final int amount = int.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }
    if (selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a payment method')));
      return;
    }

    setState(() {
      _depositing = true;
    });

    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final resp = await api.post('/payment/deposit', {
        'amount': amount,
        'paymentMethodId': selectedPaymentMethodId,
      }, headers: headers);

      print('Deposit response: $resp');

      if (resp is Map && resp['success'] == true) {
        final msg = resp['message']?.toString() ?? 'Deposit initiated';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      } else {
        final err = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Deposit failed';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    } catch (e) {
      print('Error submitting deposit: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _depositing = false;
        });
      }
    }
  }

  Future<void> _submitRecurring() async {
    if (_depositing) return;
    final int amount = int.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }
    if (selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a payment method')));
      return;
    }
    final interval = (selectedFrequency ?? 'Monthly').toLowerCase();

    setState(() {
      _depositing = true;
    });

    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final resp = await api.post('/payment/recurring', {
        'amount': amount,
        'interval': interval,
        'paymentMethodId': selectedPaymentMethodId,
      }, headers: headers);

      print('Recurring response: $resp');

      if (resp is Map && resp['success'] == true) {
        final msg = resp['message']?.toString() ?? 'Subscription created';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      } else {
        final err = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Recurring creation failed';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    } catch (e) {
      print('Error creating recurring subscription: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _depositing = false;
        });
      }
    }
  }

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

                  // Payment Methods (fetched)
                  if (_loadingMethods) ...[
                    const Center(child: CircularProgressIndicator()),
                  ] else ...[
                    if (paymentMethods.isNotEmpty)
                      Column(
                        children: paymentMethods.map((method) {
                          final id = (method['stripePaymentMethodId']?.toString() ?? method['_id']?.toString() ?? method['id']?.toString());
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethodId = id;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selectedPaymentMethodId == id ? const Color(0xFF84C67F) : const Color(0xFF2F2B3D),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.credit_card, color: Colors.white),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("XXXX - ${method["last4"] ?? method["lastFour"]}", style: const TextStyle(color: Colors.white)),
                                          Text("${method["brand"] ?? ''}", style: const TextStyle(color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (selectedPaymentMethodId == id)
                                    const Icon(Icons.check, color: Colors.white)
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F2B3D),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('No payment method added', style: TextStyle(color: Colors.white60)),
                      ),
                  ],
                  const SizedBox(height: 8),

                  // Add New Payment Method
                  GestureDetector(
                    onTap: () {
                      CardFieldInputDetails? _card;
                      //make a popup widget that uses stripe card form to add a new payment method to the user
                      //use the stripe flutter package
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          //use the stripe card form widget

                          //along with the card form, add a button to submit the card details
                          return AlertDialog(
                            backgroundColor: const Color(0xFF1E1E26),
                            title: const Text("Add New Payment Method",
                                style: TextStyle(color: Colors.white)),
                            content: SizedBox(
                                height: 400,
                                child: Column(
                                  children: [
                                    CardFormField(
                                      style: CardFormStyle(
                                          textColor: Colors.white),
                                      dangerouslyUpdateFullCardDetails: true,
                                      dangerouslyGetFullCardDetails: true,
                                      onCardChanged: (card) {
                                        _card = card;
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          if (_card == null ||
                                              !_card!.complete) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Please enter complete card details')),
                                            );
                                            return;
                                          }
                                          final paymentMethod = await Stripe
                                              .instance
                                              .createPaymentMethod(
                                            params: PaymentMethodParams.card(
                                              paymentMethodData:
                                                  PaymentMethodData(
                                                billingDetails: BillingDetails(
                                                  name: AppState().firstName +
                                                      ' ' +
                                                      AppState().lastName,
                                                  email: AppState().email,
                                                ),
                                              ),
                                            ),
                                          );
                                          print(
                                              'Payment Method created: $paymentMethod');
                                          // Send PaymentMethod ID to backend
                                          final ApiService _api_service =
                                              ApiService(
                                                  baseUrl: ApiConfig.baseUrl);
                                          try {
                                            final response =
                                                await _api_service.post(
                                              "/payment/save-card", // relative endpoint
                                              {
                                                "paymentMethodId":
                                                    paymentMethod.id,
                                              },
                                            );
                                            // Handle backend response
                                            if (response["success"] == true) {
                                              final card = response["card"];
                                              print(
                                                  "Card saved successfully: ${card["brand"]} ****${card["last4"]}");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Card added successfully')),
                                              );
                                              // refresh methods
                                              _fetchPaymentMethods();
                                            } else {
                                              print(
                                                  "Failed to save card: $response");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Failed to add card: ${response["message"]}')),
                                              );
                                            }
                                          } catch (e) {
                                            print(
                                                "Error saving card to backend: $e");
                                          }

                                          Navigator.of(context).pop();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text('Error: $e')),
                                          );
                                        }
                                      },
                                      child: const Text("Add Card"),
                                    ),
                                  ],
                                )),
                          );
                        },
                      );
                    }, // Handle action
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

                  if (isRecurring) ...[
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

                          // Show details only when a valid amount is entered
                          Builder(builder: (context) {
                            final int recurringAmount = int.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                            if (recurringAmount > 0) {
                              return Column(
                                children: [
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
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Enter a valid amount to configure recurring top-up',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Deposit Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Deposit Details",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text(
                            "You're about to confirm your deposit, please review data below.",
                            style:
                                TextStyle(color: Colors.white60, fontSize: 14)),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                            "Payment Method", selectedPaymentMethodId != null ? 'XXXX - ${paymentMethods.firstWhere((m) => ((m['stripePaymentMethodId']?.toString() ?? m['_id']?.toString() ?? m['id']?.toString())) == selectedPaymentMethodId)['last4'] ?? ''}' : selectedPaymentMethod),
                        _buildDetailRow("Deposit Amount", amountController.text),
                        _buildDetailRow("Fees", "\$0"),
                        _buildDetailRow("Total Amount", amountController.text),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deposit Button
                  SizedBox(
                    width: double.infinity,
                    child: Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: (_depositing)
                            ? null
                            : () async {
                                if (isRecurring) {
                                  await _submitRecurring();
                                } else {
                                  await _submitDeposit();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _depositing ? Colors.grey : const Color.fromRGBO(133, 187, 101, 1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: _depositing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(isRecurring ? 'Start Recurring' : 'Deposit',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                      );
                    }),
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
