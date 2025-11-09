import 'package:flutter/material.dart';
import 'package:penny/Utils/Wallet/index.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Wallet",
              style: TextStyle(
                  color: Color.fromRGBO(133, 187, 101, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Manage your payment methods and balances",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ),
            WalletBalance(),
            const SizedBox(height: 20),
            PaymentMethods(),
            const SizedBox(height: 20),
            TransactionsList(),
          ],
        ),
      ),
    );
  }
}
