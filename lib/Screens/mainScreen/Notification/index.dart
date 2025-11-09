import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1), // Dark Background
      // appbar of the screen
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
        actions: [
          SvgPicture.asset("assets/icons/Logo.svg"),
        ],
      ),
      // body of the screen
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notification",
                  style: TextStyle(
                      color: Color.fromRGBO(133, 187, 101, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
                TextButton(
                  onPressed: () {}, // Clear All Functionality
                  child: const Text(
                    "Clear All",
                    style: TextStyle(
                        color: Color.fromRGBO(133, 187, 101, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            // New Notifications Section
            _sectionTitle("New"),
            _notificationCard(
              icon: Icons.account_balance_wallet_outlined,
              title: "Withdrawal Processed",
              message:
                  "Your withdrawal of \$2,000 is being processed and will reach your bank account soon.",
              time: "2 Min Ago",
              isUnread: true,
            ),
            _notificationCard(
              icon: Icons.account_balance_wallet,
              title: "Deposit Successful",
              message:
                  "Your deposit of \$500 has been successfully added to your wallet.",
              time: "2 Min Ago",
              isUnread: true,
            ),

            // Today Section
            _sectionTitle("Today"),
            _notificationCard(
              icon: Icons.savings_outlined,
              title: "You saved pennies from a transaction!",
              message:
                  "Congratulations, you have rounded up \$2.25 from your transaction of latte @cafe.",
              time: "2 Min Ago",
            ),
            _notificationCard(
              icon: Icons.savings_outlined,
              title: "You saved pennies from a transaction!",
              message:
                  "Congratulations, you have rounded up \$2.25 from your transaction of latte @cafe.",
              time: "2 Min Ago",
            ),
            _notificationCard(
              icon: Icons.savings_outlined,
              title: "You saved pennies from a transaction!",
              message:
                  "Congratulations, you have rounded up \$2.25 from your transaction of latte @cafe.",
              time: "2 Min Ago",
            ),

            // Yesterday Section
            _sectionTitle("Yesterday"),
            _notificationCard(
              icon: Icons.credit_card,
              title: "Payment Method Expiring Soon",
              message:
                  "Your saved payment method is about to expire. Update it to avoid interruptions.",
              time: "1 Day Ago",
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Notification Card Widget
  Widget _notificationCard({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    bool isUnread = false,
  }) {
    return Card(
      color: const Color.fromRGBO(22, 22, 33, 1), // Dark Card Color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(61, 61, 82, 1),
              ),
              width: 38,
              height: 38,
              child: Icon(icon, color: Colors.white70, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isUnread)
              const Icon(
                Icons.circle,
                color: Color.fromRGBO(133, 187, 101, 1),
                size: 10,
              ), // Unread Indicator
          ],
        ),
      ),
    );
  }
}
