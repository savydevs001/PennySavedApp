import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:penny/Components/Global/Button.dart';
import 'package:penny/Screens/mainScreen/index.dart';

class OtpForm extends StatefulWidget {
  // sendOtp: function to request/resend an OTP (optional)
  // verifyOtp: function to verify entered OTP (optional)
  // nextScreen: Widget to open after successful verification (optional)
  final Future<bool> Function()? sendOtp;
  final Future<bool> Function(String code)? verifyOtp;
  final Widget? nextScreen;

  const OtpForm({
    super.key,
    this.sendOtp,
    this.verifyOtp,
    this.nextScreen,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int counterDecreasing = 59;
  String countdown = "59";
  bool allow = true;
  String _enteredCode = '';

  void startCounter() {
    allow = false;
    counterDecreasing = 59;

    // Cancel any existing timer before starting a new one
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        countdown = counterDecreasing.toString();
      });
      counterDecreasing--;
      if (counterDecreasing <= -1) {
        if (mounted) {
          setState(() {
            allow = true;
          });
        }
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: screenHeight * 0.43,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  OtpTextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.deny('.'),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    numberOfFields: 6,
                    borderWidth: 1,
                    fieldHeight: 49,
                    autoFocus: false,
                    fieldWidth: 50,
                    showFieldAsBox: true,
                    fillColor: const Color.fromRGBO(133, 187, 101, 1),
                    focusedBorderColor: const Color.fromRGBO(133, 187, 101, 1),
                    borderColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    contentPadding: const EdgeInsets.only(bottom: 2),
                    onSubmit: (code) {
                      _enteredCode = code;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Didn’t receive your code?",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  allow
                      ? InkWell(
                          onTap: () async {
                            // call provided sendOtp if available, otherwise just start counter
                            bool ok = true;
                            if (widget.sendOtp != null) {
                              ok = await widget.sendOtp!();
                            }
                            if (ok) startCounter();
                            if (!ok) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to resend OTP')),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Resend an OTP!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            text: "Resend code in ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: "00:$countdown",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(133, 187, 101, 1),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromRGBO(133, 187, 101, 1),
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              CustomButton(
                name: "Confirm",
                onPress: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _timer?.cancel(); // Cancel the timer before navigating

                  bool verified = true;
                  if (widget.verifyOtp != null) {
                    verified = await widget.verifyOtp!(_enteredCode);
                  }

                  if (!verified) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid or expired code')),
                      );
                    }
                    return;
                  }

                  if (widget.nextScreen != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => widget.nextScreen!),
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const mainScreen(initialPage: 0),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
