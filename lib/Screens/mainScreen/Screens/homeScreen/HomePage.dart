import 'package:flutter/material.dart';
import 'package:penny/Utils/PerformanceRecord/Performances.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello, Hazem",
              style: TextStyle(
                  color: Color.fromRGBO(133, 187, 101, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Your financial overview at a glance.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ),
            PortfolioPerformance(),
            const SizedBox(height: 20),
            PortfolioList(),
          ],
        ),
      ),
    );
  }
}
