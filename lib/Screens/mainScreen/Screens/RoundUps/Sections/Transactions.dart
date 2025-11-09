import 'package:flutter/material.dart';

class RoundUpsBody extends StatelessWidget {
  const RoundUpsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {"amount": "\$1.00", "title": "COFFEE @ CAFE", "date": "23 JAN 2024"},
      {"amount": "\$2.40", "title": "ESPRESSO @BARISTA", "date": "15 FEB 2024"},
      {"amount": "\$1.10", "title": "LATTE @STARBUCKS", "date": "10 MAR 2024"},
      {"amount": "\$2.10", "title": "CAPPUCCINO @COSTA", "date": "5 APR 2024"},
    ];

    return Container(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(36, 36, 51, 1),
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Round Up Transactions",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250, // Set a fixed height to prevent layout issues
              child: ListView.builder(
                shrinkWrap:
                    true, // Ensures proper layout within SingleChildScrollView
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    color: const Color.fromRGBO(36, 36, 51, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        transaction["amount"]!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(133, 187, 101, 1),
                            fontSize: 14),
                      ),
                      subtitle: Text(
                        transaction["title"]!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Column(
                        children: [
                          Text(
                            transaction["date"]!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
