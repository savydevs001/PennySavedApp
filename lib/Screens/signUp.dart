import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penny/Screens/SignInForm/SignInForm.dart';
import 'package:penny/Screens/SignUpForm/SignUpForm.dart';
import 'package:penny/Components/SocialButton.dart';
import 'package:penny/Components/Global/logo.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isSignupSelected = true; // Track selected option

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
                          height: screenHeight * 0.30,
                          width: screenWidth,
                          child: const Center(child: Logo())),
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
                              left: isSignupSelected
                                  ? 155
                                  : 0, // Moves based on selection
                              right: isSignupSelected ? 0 : 155,
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

                            // Sign In Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSignupSelected = false;
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isSignupSelected
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
                                        isSignupSelected = true;
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isSignupSelected
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
                      isSignupSelected
                          ? const SignUpForm()
                          : const SignInForm(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  child:
                                      Divider(color: Colors.grey, thickness: 1),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Or Continue with",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child:
                                      Divider(color: Colors.grey, thickness: 1),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SocialButton(
                                  icon: FontAwesomeIcons.google,
                                  text: "Google",
                                  onTap: () {
                                    // Handle Google sign-in
                                  },
                                ),
                                const SizedBox(width: 15),
                                SocialButton(
                                  icon: FontAwesomeIcons.facebook,
                                  text: "Facebook",
                                  onTap: () {
                                    // Handle Facebook sign-in
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
