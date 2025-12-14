import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/Withdrawal/ConfirmWithdrawal.dart/SubmittionWithDrawal/SubmittionWithDrawal.dart';
import 'package:penny/Services/api_service.dart';
import 'package:penny/Utils/api_config.dart';
import 'package:penny/Services/auth_service.dart';

class WithdrawConfirmationScreen extends StatefulWidget {
  final int amount;
  final String accountId;

  const WithdrawConfirmationScreen({super.key, required this.amount, required this.accountId});

  @override
  _WithdrawConfirmationScreenState createState() => _WithdrawConfirmationScreenState();
}

class _WithdrawConfirmationScreenState extends State<WithdrawConfirmationScreen> {
  bool _loading = false;

  Future<void> _submitWithdrawal() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });

    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final resp = await api.post('/payment/withdraw', {
        'amount': widget.amount,
        'accountId': widget.accountId,
      }, headers: headers);

      print('Withdraw response: $resp');

      if (!mounted) return;

      if (resp is Map && resp['success'] == true) {
        final msg = resp['message']?.toString() ?? 'Withdrawal initiated';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WithdrawRequestSubmittedScreen()),
        );
      } else {
        final err = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Withdrawal failed';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    } catch (e) {
      print('Error submitting withdrawal: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Confirmation Card

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(47, 43, 61, 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Withdrawal Confirmation",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text(
                      "You're about to confirm your withdrawal, please review data below.",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow("Payment Method", widget.accountId),
                    _buildDetailRow("Withdrawal Amount", "\$${widget.amount}"),
                    _buildDetailRow("Fees", "\$2"),
                    _buildDetailRow("Total Amount", "\$${widget.amount - 2}"),
                    _buildDetailRow(
                        "Estimated Transfer Time", "1 - 3 Business Days"),
                    const SizedBox(height: 20),
                    const Divider(),

                    // Confirm & Withdraw Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : () async {
                          await _submitWithdrawal();
                        }, // Handle withdrawal
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(133, 187, 101, 1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Confirm & Withdraw",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for details row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }
}
