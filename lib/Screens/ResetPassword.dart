import 'package:flutter/material.dart';
import 'package:penny/Components/EmailTextField.dart';
import 'package:penny/Components/PhoneTextField.dart';

class ResetPassword extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ResetPassword());
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isPhoneSelected = true; // Track selected option

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents UI from moving up
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.4,
                        width: screenWidth,
                        child: Center(
                            child: Image.asset("assets/images/L-Lock.png")),
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.8,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Did you forget your password?",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromRGBO(133, 187, 101, 1)),
                            ),
                            Text(
                              "We will send you an OTP through your email or phone number to get it back.",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(179, 181, 188,
                              0.5), // Background color for the toggle
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          children: [
                            // Moving Gradient Indicator
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              left: isPhoneSelected
                                  ? 155
                                  : 0, // Moves based on selection
                              right: isPhoneSelected ? 0 : 155,
                              child: Container(
                                height: 50,
                                width: 1,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(133, 187, 101, 1),
                                      Color.fromRGBO(238, 195, 88, 1)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),

                            // Sign In Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPhoneSelected = false;
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        "Phone Number",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isPhoneSelected
                                              ? Colors.white70
                                              : Colors
                                                  .black, // Change color based on selection
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Sign Up Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPhoneSelected = true;
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        "E-Mail",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isPhoneSelected
                                              ? Colors.black
                                              : Colors
                                                  .white70, // Change color based on selection
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Conditional Form Based on Selection
                      isPhoneSelected
                          ? const EmailOtpForm()
                          : const PhoneOtpForm(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
