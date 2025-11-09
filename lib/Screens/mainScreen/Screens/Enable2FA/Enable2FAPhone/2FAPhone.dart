import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:penny/Screens/mainScreen/Screens/Enable2FA/Enable2FAPhone/EnableOtp/2FAOtp.dart';

class ConfirmationDialog {
  static void showConfirmationDialog({
    required BuildContext context,
    required bool isPhoneSelected,
    required Function(bool) onToggle,
    required TextEditingController emailController,
    required TextEditingController phoneController,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          double screenWidth = MediaQuery.of(context).size.width;

          return SimpleDialog(
              backgroundColor: const Color.fromRGBO(36, 36, 51, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide.none),
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
                          "Confirmation Process",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Please choose a contact method to receive the code on",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(153, 156, 166, 1),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 50,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(179, 181, 188, 0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                left: isPhoneSelected ? 135 : 0,
                                right: isPhoneSelected ? 0 : 135,
                                child: Container(
                                  height: 50,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                : Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPhoneSelected = true;
                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          "Email",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: isPhoneSelected
                                                ? Colors.black
                                                : Colors.white70,
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
                        isPhoneSelected
                            ? TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: "Email Address",
                                  hintText: "Enter Email",
                                  filled: true,
                                  fillColor: Color.fromRGBO(36, 36, 51, 1),
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(color: Colors.white),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: IntlPhoneField(
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                    labelText: "Phone Number",
                                    filled: true,
                                    fillColor: Color.fromRGBO(36, 36, 51, 1),
                                    border: OutlineInputBorder(),
                                  ),
                                  initialCountryCode: 'US',
                                  style: const TextStyle(color: Colors.white),
                                  dropdownTextStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                              ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(133, 187, 101, 1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            OtpEnableDialog.showOtpEnableDialog(
                              context: context,
                              isPhoneSelected: isPhoneSelected,
                              onToggle: (bool value) {
                                setState(() {
                                  isPhoneSelected = value;
                                });
                              },
                              emailController: emailController,
                              phoneController: phoneController,
                            );
                          },
                          child: const Center(
                            child: Text(
                              "Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ))
              ]);
        });
  }
}
