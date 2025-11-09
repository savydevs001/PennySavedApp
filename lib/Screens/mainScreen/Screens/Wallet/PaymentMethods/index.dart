import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Screens/mainScreen/Notification/index.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/PaymentMethods/CardInfo/CardInfo.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool isChanged = false; // To track if changes were made

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "brand": "Mastercard",
      "lastFour": "4371",
      "expiry": "08/28",
      "isPrimary": true,
    },
    {
      "brand": "Visa",
      "lastFour": "5137",
      "expiry": "08/28",
      "isPrimary": false,
    }
  ];

  void _onCardTap(int index) {
    setState(() {
      for (var method in paymentMethods) {
        method["isPrimary"] = false;
      }
      paymentMethods[index]["isPrimary"] = true;
      isChanged = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CardInformationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C27),
      appBar: AppBar(
        title: const Text("Payment Methods",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/appbar/Back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
        elevation: 0,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/appbar/Notifications.svg',
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(paymentMethods.length, (index) {
              final method = paymentMethods[index];
              return GestureDetector(
                onTap: () {
                  _onCardTap(index);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2B3D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            method["brand"] == "Visa"
                                ? Icons.credit_card
                                : Icons.payment,
                            color: method["brand"] == "Visa"
                                ? Colors.blue
                                : Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "XXXX - ${method["lastFour"]}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Expires in ${method["expiry"]}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (method["isPrimary"])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(133, 187, 101, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "Primary",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          const SizedBox(width: 10),
                          const Icon(Icons.more_vert, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: isChanged ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                disabledBackgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
