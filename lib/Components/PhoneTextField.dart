import 'package:flutter/material.dart';
import 'package:penny/Components/Global/Button.dart';
import 'package:penny/Components/Global/TextField.dart';
import 'package:penny/Screens/ResetPasswordTextField.dart';

class PhoneOtpForm extends StatefulWidget {
  const PhoneOtpForm({super.key});

  @override
  State<PhoneOtpForm> createState() => _PhoneOtpFormState();
}

class _PhoneOtpFormState extends State<PhoneOtpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  bool isVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your valid Phone Number";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid Phone Number.";
    }
    return null;
  }

  void setVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
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
          height: screenHeight * 0.35,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                controller: _emailController,
                hintText: "Please enter your Phone Number",
                labelText: 'Phone Number',
                validator: _validateEmail,
              ),
              CustomButton(
                name: "SEND OTP to Phone Number",
                onPress: () {
                  Navigator.push(context, ResetPasswordTextField.route());
                  // if (_formKey.currentState!.validate()) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text("Otp Send Successfully!")),
                  //   );
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
