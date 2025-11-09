// Sign Up Form
import 'package:flutter/material.dart';
import 'package:penny/Components/Global/Button.dart';
import 'package:penny/Components/Global/TextField.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  bool isVisible = false;
  bool isVisibleforConfirm = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a valid email address.";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Your password doesn't match the first one you entered";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Your password doesn't match the first one you entered";
    }
    return null;
  }

  void setVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void setVisibilityForConfirm() {
    setState(() {
      isVisibleforConfirm = !isVisibleforConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            controller: _emailController,
            validator: _validateEmail,
            hintText: "Email Address",
            labelText: 'Email Address',
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: screenWidth * 0.5,
              child: const CustomTextField(
                hintText: 'First Name',
                labelText: 'First Name',
              ),
            ),
            SizedBox(
              width: screenWidth * 0.5,
              child: const CustomTextField(
                hintText: 'Last Name',
                labelText: 'Last Name',
              ),
            ),
          ]),
          CustomTextField(
            hintText: "Password",
            isPassword: isVisible,
            labelText: 'Password',
            suffixIcon: isVisible
                ? IconButton(
                    icon: const Icon(Icons.visibility_off_outlined),
                    onPressed: () {
                      setVisibility();
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      setVisibility();
                    },
                  ),
          ),
          CustomTextField(
            hintText: "Password Confirmation",
            isPassword: isVisibleforConfirm,
            labelText: 'Password Confirmation',
            validator: _validatePassword,
            suffixIcon: isVisibleforConfirm
                ? IconButton(
                    icon: const Icon(Icons.visibility_off_outlined),
                    onPressed: () {
                      setVisibilityForConfirm();
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      setVisibilityForConfirm();
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Checkbox(value: true, onChanged: (val) {}),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    children: [
                      const TextSpan(text: "I agree to the "),
                      WidgetSpan(
                        child: GestureDetector(
                          child: const Text(
                            "terms and conditions policy",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(133, 187, 101, 1),
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromRGBO(133, 187, 101, 1),
                                decorationThickness: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            name: "Sign Up",
            onPress: () {
              print("hello!");

              final emailError = _validateEmail(_emailController.text);
              if (emailError == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sign-up Successful!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(emailError)),
                );
              }
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sign-up Successful!")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
