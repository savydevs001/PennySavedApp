import 'package:flutter/material.dart';
import 'package:penny/Components/Global/Button.dart';
import 'package:penny/Components/Global/TextField.dart';
import 'package:penny/Screens/OtpForResentPassword.dart';

class NewPhoneEnterForm extends StatefulWidget {
  const NewPhoneEnterForm({super.key});

  @override
  State<NewPhoneEnterForm> createState() => _NewPhoneEnterFormState();
}

class _NewPhoneEnterFormState extends State<NewPhoneEnterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  bool isVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your Phone Number";
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
          height: screenHeight * 0.43,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Please enter your New Phone Number",
                      labelText: 'New Phone Number',
                      validator: _validateEmail,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Please Confirm your New Phone Number",
                      labelText: 'Confirm New Phone Number',
                      validator: _validateEmail,
                    ),
                  ],
                ),
              ),
              CustomButton(
                name: "Confirm",
                onPress: () {
                  print("hello");
                  Navigator.push(context, ResetPasswordOtp.route());
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
