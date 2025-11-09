import 'package:flutter/material.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/RecurringTopUp/RecurringTopUpEdit/index.dart';

class RecurringTopUp extends StatefulWidget {
  const RecurringTopUp({super.key});

  @override
  State<RecurringTopUp> createState() => _RecurringTopUpState();
}

class _RecurringTopUpState extends State<RecurringTopUp> {
  List<bool> statusList = [
    true,
    false,
    true,
    true,
    true,
    true,
    true,
    false,
    true,
    false
  ]; // Example statuses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
      ),
      backgroundColor: const Color.fromRGBO(
          22, 22, 33, 1), // Background color for better visibility
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(36, 36, 51, 1),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: statusList.length,
                    itemBuilder: (context, index) {
                      return _buildTopUpItem(
                        amount: "\$1,250",
                        nextDate: "17 Oct 2024",
                        isActive: statusList[index],
                        onToggle: (value) {
                          setState(() {
                            statusList[index] = value;
                          });
                        },
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RecurringTopUpEditScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Individual Top-Up Item
  Widget _buildTopUpItem({
    required String amount,
    required String nextDate,
    required bool isActive,
    required ValueChanged<bool> onToggle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left section (Weekly & Amount)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "WEEKLY",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "STATUS",
                      style: TextStyle(
                        color: isActive
                            ? const Color.fromRGBO(133, 187, 101, 1)
                            : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Right section (Next Top Up Date & Switch)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "NEXT TOP UP DATE",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      nextDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Switch(
                      value: isActive,
                      onChanged: onToggle,
                      activeColor: const Color.fromRGBO(133, 187, 101, 1),
                      inactiveTrackColor: Colors.red,
                      inactiveThumbColor: Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade800, thickness: 0.5),
        ],
      ),
    );
  }
}
