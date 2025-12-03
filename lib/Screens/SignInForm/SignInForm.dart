import 'package:flutter/material.dart';
import 'package:penny/Components/Global/Button.dart';
import 'package:penny/Components/Global/TextField.dart';
import 'package:penny/Screens/ResetPassword.dart';
import 'package:penny/Screens/OtpForResentPassword.dart';
import 'package:penny/Services/auth_service.dart';
import 'package:penny/Screens/mainScreen/Screens/homeScreen/HomePage.dart';
import 'package:penny/Screens/mainScreen/index.dart';
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            hintText: "Email Address",
            labelText: 'Email Address',
            validator: _validateEmail,
          ),
          CustomTextField(
            controller: _passwordController,
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(value: true, onChanged: (val) {}),
                const Text(
                  "Remember Me",
                  style: TextStyle(color: Colors.white),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, ResetPassword.route());
                  },
                  child: const Text("Forgot Password?",
                      style:
                          TextStyle(color: Color.fromRGBO(133, 187, 101, 1))),
                ),
              ],
            ),
          ),
          CustomButton(
            name: "Sign In",
            onPress: () async {
              if (!_formKey.currentState!.validate()) return;

              final email = _emailController.text.trim();
              final password = _passwordController.text;

              // call AuthService.login
              final result = await AuthService().login(email, password);

              final status = result['statusCode'] ?? 500;
              final message = result['message'] ?? 'An error occurred';

              if (status == 404) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User not found')),
                );
                return;
              }

              if (status == 401) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid credentials')),
                );
                return;
              }

              if (result['twoFactorRequired'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
                // navigate to OTP screen: pass send/verify callbacks and nextScreen
                Navigator.push(
                  context,
                  ResetPasswordOtp.route(
                    sendOtp: () => AuthService().sendOtp(email, purpose: 'login'),
                    verifyOtp: (code) => AuthService().verifyOtp(email, code, purpose: 'login'),
                    nextScreen: const mainScreen(initialPage: 0),
                  ),
                );
                return;
              }

              if (result['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
                // Navigate to home/dashboard
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const mainScreen()),
                );
                return;
              }

              // fallback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          ),
        ],
      ),
    );
  }
}
