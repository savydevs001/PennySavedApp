import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:penny/Screens/mainScreen/Screens/Disable2FA/Disable2FA.dart';

class ConfirmEnableDialog {
  static void showConfirmEnableDialog({
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              backgroundColor: const Color.fromRGBO(36, 36, 51, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide.none),
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                      return (Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/Tick.svg'),
                          ),
                          const Text(
                            textAlign: TextAlign.center,
                            "Two-factor authentication has been successfully enabled!",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SecurityDisableScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(133, 187, 101, 1),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 50.0, right: 50),
                              child: Text("Finish",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ));
                    }),
                  ),
                ),
              ]);
        });
  }
}







                               // Handle withdrawal
                                