import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:penny/Screens/mainScreen/Notification/index.dart';
import '../../../../Services/api_service.dart';
import '../../../../Utils/api_config.dart';
import '../../../../Services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/app_state.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: const Color.fromRGBO(22, 22, 33, 1),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(47, 43, 61, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.support_agent, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Contact Support",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Center(
                Center(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      "assets/icons/help.png",
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),

                // child: SizedBox(
                //     height: 120,
                //     width: 120,
                //     child: SvgPicture.asset("assets/icons/help.svg")),
                // ),
                const SizedBox(height: 20),
                const Text(
                  "Your Problem / Suggestion",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                    ),
                    hintText: "Enter your inquiry here.",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                          text: "Email: ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      TextSpan(
                        text: "pennysaved@gmail.com",
                        style: TextStyle(
                            color: Color.fromRGBO(133, 187, 101, 1),
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(text: "Phone Number: "),
                      TextSpan(
                        text: "+123456789123",
                        style: TextStyle(
                            color: Color.fromRGBO(133, 187, 101, 1),
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 200),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _submitContact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(133, 187, 101, 1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitContact() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a message')));
      return;
    }
    try {
      final api = ApiService(baseUrl: ApiConfig.baseUrl);
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final appState = Provider.of<AppState>(context, listen: false);
      final userName = ((appState.firstName + ' ' + appState.lastName).trim().isNotEmpty) ? (appState.firstName + ' ' + appState.lastName).trim() : 'Website Visitor';
      final userEmail = (appState.email.isNotEmpty) ? appState.email : 'visitor@pennysavedllc.com';

      final resp = await api.post(ApiConfig.contact, {
        'name': userName,
        'email': userEmail,
        'message': message
      }, headers: headers);
      final msg = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Response received';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      if (resp is Map && resp['success'] == true) {
        _messageController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contact failed: $e')));
    }
  }
}
