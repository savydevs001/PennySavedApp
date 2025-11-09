import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.name,
    required this.onPress,
  });

  final String name;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Expanded(
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            height: screenHeight * 0.05,
            width: screenWidth * 0.9,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(133, 187, 101, 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
