import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Providers/app_state.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/Withdrawal/ConfirmWithdrawal.dart/ConfirmWithdrawal.dart';
import 'package:penny/Services/api_service.dart';
import 'package:penny/Utils/api_config.dart';
import 'package:penny/Services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WithdrawFundsScreen extends StatefulWidget {
  const WithdrawFundsScreen({super.key});

  @override
  _WithdrawFundsScreenState createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  //stripe status
  bool _loadingStripe = true;
  bool payoutsEnabled = false;
  bool chargesEnabled = false;
  Map<String, dynamic>? stripeInfo;
  Map<String, dynamic>? externalAccount;
  String? onboardingLink;

  //only allow numbers (no decimals) in amount input
  final TextEditingController amountController = TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    _fetchStripeStatus();
  }

  Future<void> _fetchStripeStatus() async {
    setState(() {
      _loadingStripe = true;
    });
    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final resp = await api.get(ApiConfig.stripeStatus, headers: headers);
      print('Stripe Status response: $resp');
      if (resp is Map && resp['success'] == true) {
        if (!mounted) return;
        setState(() {
          stripeInfo = Map<String, dynamic>.from(resp);
          payoutsEnabled = resp['payoutsEnabled'] == true;
          chargesEnabled = resp['chargesEnabled'] == true;
          if (resp['externalAccounts'] is List && (resp['externalAccounts'] as List).isNotEmpty) {
            externalAccount = Map<String, dynamic>.from((resp['externalAccounts'] as List).first);
          } else {
            externalAccount = null;
          }
        });
      }
    } catch (e) {
      print('Error fetching stripe status: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingStripe = false;
        });
      }
    }
  }

  Future<void> _createOnboarding() async {
    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final resp = await api.post(ApiConfig.onboardingLink,{}, headers: headers);
      print('Onboarding response: $resp');

      if (resp is Map && resp['url'] != null) {
        onboardingLink = resp['url'].toString();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Onboarding link: $onboardingLink')));
        if (onboardingLink != null) {
          final uri = Uri.parse(onboardingLink!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch onboarding link')));
          }
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not get onboarding link')));
      }
    } catch (e) {
      print('Error creating onboarding link: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    int walletBalance = appState.walletBalance as int;
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
                  const Text("Withdraw Funds",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Amount Input
                  const Text("Amount \$",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(height: 8),
                  TextField(
                    inputFormatters: [
                      //ALLOW ONLY NUMBERS NO DECIMALS
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
                    controller: amountController,
                    onChanged: (val) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E1E26),
                      labelStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            amountController.text = walletBalance.toString();
                          });
                        },
                        child: Container(
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
                      )),
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
                      Text("Maximum withdrawal available is: \$$walletBalance",
                          style:
                              TextStyle(color: Colors.white60, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment Method
                  const Text("Payment Method",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(height: 8),

                  if (_loadingStripe) ...[
                    const Center(child: CircularProgressIndicator()),
                  ] else ...[
                    if (externalAccount != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F2B3D),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${externalAccount!['bank_name'] ?? 'Bank Account'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'XXXX - ${externalAccount!['last4'] ?? ''}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              '${externalAccount!['status'] ?? ''}',
                              style: TextStyle(
                                  color: (externalAccount!['status'] == 'verified') ? Colors.greenAccent : Colors.amber),
                            )
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F2B3D),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('No payout method added', style: TextStyle(color: Colors.white60)),
                      ),

                    const SizedBox(height: 8),

                    if (!payoutsEnabled || !chargesEnabled) ...[
                      const Text('Payouts or charges are disabled for your account. You must add a payout method to withdraw.', style: TextStyle(color: Colors.white60)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await _createOnboarding();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        child: const Text('Add Payout Method', style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 16),
                    ]
                  ],

                  // Withdrawal Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Builder(builder: (context) {
                      final int amount = int.tryParse(amountController.text) ?? 0;
                      final bool validAmount = amount > 0 && amount <= walletBalance;
                      if (validAmount) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Withdrawal Details",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text(
                                "You're about to confirm your withdrawal, please review data below.",
                                style: TextStyle(color: Colors.white60, fontSize: 14)),
                            const SizedBox(height: 12),
                            _buildDetailRow("Payment Method", externalAccount != null ? '${externalAccount!['bank_name'] ?? ''} (XXXX - ${externalAccount!['last4'] ?? ''})' : 'No payout method'),
                            _buildDetailRow("Withdrawal Amount", "\$$amount"),
                            _buildDetailRow("Fees", "\$2"),
                            _buildDetailRow("Total Amount", "\$${amount + 2}"),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Withdrawal Details",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(
                                "Please enter a valid amount to see withdrawal details.",
                                style: TextStyle(color: Colors.white60, fontSize: 14)),
                          ],
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Withdraw Button
                  SizedBox(
                    width: double.infinity,
                    child: Builder(builder: (context) {
                      final int amount = int.tryParse(amountController.text) ?? 0;
                      final bool validAmount = amount > 0 && amount <= walletBalance;
                      final bool canWithdraw = validAmount && payoutsEnabled && chargesEnabled && externalAccount != null;

                      return ElevatedButton(
                        onPressed: canWithdraw
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WithdrawConfirmationScreen(
                                      amount: int.parse(amountController.text),
                                      accountId: externalAccount!['id'].toString(),
                                    ),
                                  ),
                                );
                              }
                            : () {
                                final int amount = int.tryParse(amountController.text) ?? 0;
                                if (amount <= 0 || amount > walletBalance) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount within your balance')));
                                } else if (!payoutsEnabled || !chargesEnabled) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payouts or charges disabled. Add payout method.')));
                                } else if (externalAccount == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No payout method found. Add payout method.')));
                                }
                              },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: canWithdraw ? const Color.fromRGBO(133, 187, 101, 1) : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text("Withdraw",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
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
