import 'package:flutter/material.dart';
import 'package:penny/Screens/OtpForm/OtpForm.dart';

class ResetPasswordOtp extends StatefulWidget {
  final Future<bool> Function()? sendOtp;
  final Future<bool> Function(String code)? verifyOtp;
  final Widget? nextScreen;

  static route({
    Future<bool> Function()? sendOtp,
    Future<bool> Function(String code)? verifyOtp,
    Widget? nextScreen,
  }) =>
      MaterialPageRoute(
          builder: (context) => ResetPasswordOtp(
                sendOtp: sendOtp,
                verifyOtp: verifyOtp,
                nextScreen: nextScreen,
              ));

  const ResetPasswordOtp({
    super.key,
    this.sendOtp,
    this.verifyOtp,
    this.nextScreen,
  });

  @override
  State<ResetPasswordOtp> createState() => _ResetPasswordOtpState();
}

class _ResetPasswordOtpState extends State<ResetPasswordOtp> {
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
                              "Verification Code",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromRGBO(133, 187, 101, 1)),
                            ),
                            Text(
                              "We have sent the verification code to your email address.",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      OtpForm(
                        sendOtp: widget.sendOtp,
                        verifyOtp: widget.verifyOtp,
                        nextScreen: widget.nextScreen,
                      )
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
