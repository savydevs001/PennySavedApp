import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Components/Global/logo.dart';
import 'package:penny/Components/mainScreen/BottomNavigation.dart';
import 'package:penny/Screens/mainScreen/Notification/index.dart';
import 'package:penny/Screens/mainScreen/Screens/Account/Account.dart';
import 'package:penny/Screens/mainScreen/Screens/ContactSupport/ContactSupport.dart';
import 'package:penny/Screens/mainScreen/Screens/RoundUps/RoundUps.dart';
import 'package:penny/Screens/mainScreen/Screens/Settings/Settings.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/AddFunds/AddFund.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/PaymentMethods/index.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/Wallet.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/Withdrawal/withdrawal.dart';
import 'package:penny/Screens/mainScreen/Screens/homeScreen/HomePage.dart';
import 'package:penny/Screens/signUp.dart';

// main screen
class mainScreen extends StatefulWidget {
  static route({int initialPage = 0}) => MaterialPageRoute(
      builder: (context) => mainScreen(initialPage: initialPage));

  final int initialPage;

  const mainScreen({super.key, this.initialPage = 0});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late PageController pagescontrol;
  int _currentnavitem = 0;

  List<Widget> pages = [
    const HomePage(),
    const WalletScreen(),
    const RoundUpsScreen(),
    const AccountScreen(),
    const SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
    _currentnavitem = widget.initialPage;
    pagescontrol = PageController(initialPage: widget.initialPage);
  }

  void navigateToPage(int index) {
    setState(() {
      _currentnavitem = index;
    });
    pagescontrol.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
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
      backgroundColor: const Color.fromRGBO(36, 36, 51, 1),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(36, 36, 51, 1),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              const Logo(),
              const SizedBox(height: 10),
              const SizedBox(height: 5),
              const Row(children: [
                SizedBox(
                  width: 70,
                ),
                Column(children: [
                  Text(
                    "\$78,450",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Hello, Hazem",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ]),
              ]),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.home, color: Colors.white, size: 24),
                      title: const Text(
                        "Home",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        navigateToPage(0);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.wallet,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Wallet",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        navigateToPage(1);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.attach_money,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Round - Ups",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        navigateToPage(2);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Notifications",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        navigateToPage(3);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Account",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        navigateToPage(4);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Settings",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        navigateToPage(5);
                      },
                    ),
                    const Divider(
                        color: Colors.white24,
                        thickness: 1,
                        indent: 15,
                        endIndent: 15),
                    ListTile(
                      leading: const Icon(Icons.credit_card,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Payment Methods",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentMethodScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_balance,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Deposit Fund",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddFundsScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.money_off,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Withdraw Fund",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WithdrawFundsScreen()));
                      },
                    ),
                    const Divider(
                        color: Colors.white24,
                        thickness: 1,
                        indent: 15,
                        endIndent: 15),
                    ListTile(
                      leading: const Icon(Icons.support_agent,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Contact Support",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ContactSupportScreen()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout,
                          color: Colors.white, size: 24),
                      title: const Text(
                        "Log Out",
                        style: TextStyle(color: Colors.redAccent, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
          controller: pagescontrol,
          onPageChanged: (index) {
            setState(() {
              _currentnavitem = index;
            });
          },
          children: pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        selectedItemColor: const Color.fromRGBO(133, 187, 101, 1),
        unselectedItemColor: Colors.white,
        currentIndex: _currentnavitem,
        onTap: navigateToPage,
        // main screen navigations
        items: [
          BottomNavBarItem.bottomNavigationBaritem(
              "assets/icons/HomeInactiveIcon/Home.svg",
              "assets/icons/HomeActiveIcon/HomeActive.svg",
              "Home"),
          BottomNavBarItem.bottomNavigationBaritem(
              "assets/icons/HomeInactiveIcon/Wallet.svg",
              "assets/icons/HomeActiveIcon/WalletActive.svg",
              "Wallet"),
          BottomNavBarItem.bottomNavigationBaritem(
              "assets/icons/HomeInactiveIcon/Dollar.svg",
              "assets/icons/HomeActiveIcon/DollarActive.svg",
              "Round Ups"),
          BottomNavBarItem.bottomNavigationBaritem(
              "assets/icons/HomeInactiveIcon/User.svg",
              "assets/icons/HomeActiveIcon/UserActive.svg",
              "Account"),
          BottomNavBarItem.bottomNavigationBaritem(
              "assets/icons/HomeInactiveIcon/Setting.svg",
              "assets/icons/HomeActiveIcon/SettingActive.svg",
              "Settings"),
        ],
        backgroundColor: const Color.fromRGBO(36, 36, 51, 1),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        iconSize: 30,
      ),
    );
  }
}
