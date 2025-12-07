import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:penny/Screens/mainScreen/Notification/index.dart';
import 'package:penny/Screens/mainScreen/Screens/Wallet/PaymentMethods/CardInfo/CardInfo.dart';
import 'package:penny/Services/api_service.dart';
import 'package:penny/Utils/api_config.dart';
import 'package:penny/Services/auth_service.dart';
import 'dart:async';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool isChanged = false; // To track if changes were made
  List<Map<String, dynamic>> paymentMethods = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
  }

  Future<void> _fetchPaymentMethods() async {
    setState(() {
      _loading = true;
    });
    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final resp = await api.get('/payment/saved-methods', headers: headers);
      if (resp is Map && resp['success'] == true && resp['paymentMethods'] is List) {
        final list = (resp['paymentMethods'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
        setState(() {
          paymentMethods = list;
        });
      } else {
        // leave empty
      }
    } catch (e) {
      print('Error fetching payment methods: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

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
            if (_loading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else ...List.generate(paymentMethods.length, (index) {
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
                                "XXXX - ${method["last4"] ?? method["lastFour"]}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Expires in ${method["expMonth"]?.toString().padLeft(2,'0')}/${method["expYear"]?.toString().substring(2) ?? ''}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (method["isPrimary"] ?? false)
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
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () async {
                              final id = method['_id']?.toString() ?? method['id']?.toString();
                              if (id == null || id.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid payment method id')));
                                return;
                              }
                              if (paymentMethods.length <= 1) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot delete the last payment method')));
                                return;
                              }
                              // call DELETE
                              try {
                                final api = ApiService(baseUrl: ApiConfig.baseUrl);
                                final token = await AuthService().getToken();
                                Map<String, String> headers = {'Content-Type': 'application/json'};
                                if (token != null) headers['Authorization'] = 'Bearer $token';

                                final resp = await api.delete('/payment/methods/$id', headers: headers);
                                final msg = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Delete response';
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                                if (resp is Map && resp['success'] == true) {
                                  setState(() {
                                    paymentMethods.removeAt(index);
                                    isChanged = true;
                                    // ensure some method is primary
                                    if (!paymentMethods.any((m) => m['isPrimary'] == true) && paymentMethods.isNotEmpty) {
                                      paymentMethods[0]['isPrimary'] = true;
                                    }
                                  });
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
                              }
                            },
                          ),
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
