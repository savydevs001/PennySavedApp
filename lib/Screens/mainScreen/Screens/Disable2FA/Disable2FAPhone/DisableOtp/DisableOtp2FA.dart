import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter/services.dart';
import 'package:penny/Screens/mainScreen/Screens/Disable2FA/Disable2FAPhone/DisableOtp/ConfirmDisable/ConfirmDisable.dart';

class OtpDisableDialog {
  static void showOtpDisableDialog({
    required BuildContext context,
  }) {
    bool allow = true;
    int counterDecreasing = 59;
    String countdown = "59";
    Timer? timer;

    void stopTimer() {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
        allow = true;
      }
    }

    void startCounter(Function(void Function()) setState) {
      stopTimer();
      allow = false;
      counterDecreasing = 59;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          countdown = counterDecreasing.toString();
        });
        counterDecreasing--;
        if (counterDecreasing < 0) {
          setState(() {
            allow = true;
          });
          timer.cancel();
        }
      });
    }

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            stopTimer(); // Stop timer when the dialog is closed
            return true;
          },
          child: SimpleDialog(
            backgroundColor: const Color.fromRGBO(36, 36, 51, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide.none,
            ),
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Disable two-factor authentication",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Please enter your 6-digit number to disable the two-factor authentication process",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(153, 156, 166, 1),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: OtpTextField(
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
                              numberOfFields: 5,
                              borderWidth: 1,
                              fieldHeight: 49,
                              autoFocus: false,
                              fieldWidth: 50,
                              showFieldAsBox: true,
                              fillColor: const Color.fromRGBO(133, 187, 101, 1),
                              focusedBorderColor:
                                  const Color.fromRGBO(133, 187, 101, 1),
                              borderColor: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              contentPadding: const EdgeInsets.only(bottom: 2),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Didn’t receive your code?",
                            style: TextStyle(color: Colors.white),
                          ),
                          allow
                              ? InkWell(
                                  onTap: () => startCounter(setState),
                                  child: const Text(
                                    "Resend an OTP!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
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
                                          color:
                                              Color.fromRGBO(133, 187, 101, 1),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                stopTimer();
                                Navigator.pop(context);
                                ConfirmDisableDialog.showConfirmDisableDialog(
                                  context: context,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 0, 0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text("Disable",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      stopTimer(); // Stop timer when dialog is dismissed by tapping outside
    });
  }
}
