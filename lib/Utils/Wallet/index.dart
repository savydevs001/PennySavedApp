import 'package:flutter/material.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/AddFunds/AddFund.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/PaymentMethods/index.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/RecurringTopUp/Index.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/Withdrawal/withdrawal.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(47, 43, 61, 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Balance",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 10),
                  Text("\$21,459",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromRGBO(76, 175, 80, 0.5)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8),
                  child: Text("+29%",
                      style: TextStyle(
                        color: Color.fromRGBO(133, 187, 101, 1),
                        fontSize: 16,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    backgroundColor: Colors.transparent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WithdrawFundsScreen()),
                  );
                },
                child: const Text(
                  "Withdraw",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(133, 187, 101, 1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFundsScreen()),
                  );
                },
                child: const Text(
                  "Add Fund",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PaymentMethodScreen()),
            );
          },
          child: Container(
            width: 156,
            height: 108,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(47, 43, 61, 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Color.fromRGBO(253, 182, 3, 0.16),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    size: 25,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: const Text(
                    "Linked Payment Methods",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow
                        .ellipsis, // Optional: Adds ellipsis for overflow
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecurringTopUp()),
              );
            },
            child: Container(
              height: 108,
              width: 156,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(47, 43, 61, 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Color.fromRGBO(255, 76, 81, 0.16),
                    ),
                    child: const Icon(
                      Icons.autorenew,
                      size: 25,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Recurring Top Up",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionsList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      "amount": "\$1,250",
      "type": "WITHDRAWAL",
      "status": "Completed",
      "date": "21 JAN 2024",
      "color": const Color.fromRGBO(133, 187, 101, 1)
    },
    {
      "amount": "\$1,250",
      "type": "DEPOSIT",
      "status": "Pending",
      "date": "21 JAN 2024",
      "color": Colors.orange
    },
    {
      "amount": "\$1,250",
      "type": "DEPOSIT",
      "status": "Failed",
      "date": "21 JAN 2024",
      "color": Colors.red
    },
  ];

  TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Transactions",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    backgroundColor: Colors.transparent),
                child: Text(
                  "Withdrawal",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    backgroundColor: Colors.transparent),
                child: Text(
                  "Deposit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text(transactions[index]["amount"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text(
                      transactions[index]["type"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      transactions[index]["status"],
                      style: TextStyle(color: transactions[index]["color"]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
