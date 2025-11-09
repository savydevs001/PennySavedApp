import 'package:flutter/material.dart';
import 'package:penny/Components/Global/logo.dart';
import 'package:penny/Screens/mainScreen/index.dart';

class FundSubmittedScreen extends StatelessWidget {
  const FundSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1), // Dark background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section

              const SizedBox(height: 50),
              const Logo(),
              const SizedBox(height: 150),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(47, 43, 61, 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Color.fromRGBO(83, 210, 140, 1), size: 60),
                        SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text("Payment Successful",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text(
                      "You've successfully added \$100 to your wallet. Keep saving to reach your investment goal!",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow("Payment Method", "****1234 Debit Card"),
                    _buildDetailRow("Deposite Amount", "\$2,450"),
                    _buildDetailRow("Fees", "\$2"),
                    _buildDetailRow("Total Amount", "\$2,448"),
                    _buildDetailRow("Transaction ID", "#12345"),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    // Wallet & Home Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const mainScreen(
                                        initialPage: 1,
                                      )),
                            );
                          }, // Navigate to Wallet
                          label: const Padding(
                            padding: EdgeInsets.only(
                                top: 8, bottom: 8, left: 12, right: 12),
                            child: Text("Wallet",
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 14)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orange),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const mainScreen(
                                        initialPage: 0,
                                      )),
                            );
                          }, // Navigate to Home

                          label: const Padding(
                            padding: EdgeInsets.only(
                                top: 8, bottom: 8, left: 12, right: 12),
                            child: Text("Home",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(133, 187, 101, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
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
