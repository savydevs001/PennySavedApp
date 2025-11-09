import 'package:flutter/material.dart';
import 'package:penny/Components/Global/Button.dart';
import 'package:penny/Components/Global/TextField.dart';

class EmailOtpForm extends StatefulWidget {
  const EmailOtpForm({super.key});

  @override
  State<EmailOtpForm> createState() => _EmailOtpFormState();
}

class _EmailOtpFormState extends State<EmailOtpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  bool isVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email address.";
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
                hintText: "Please enter your email",
                labelText: 'Email Address',
                validator: _validateEmail,
              ),
              CustomButton(
                name: "SEND OTP",
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Otp Send Successfully!")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
