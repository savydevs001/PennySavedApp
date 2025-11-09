import 'package:flutter/material.dart';
import 'package:penny/Screens/mainScreen/Screens/RoundUps/Sections/QuickActions.dart';
import 'package:penny/Screens/mainScreen/Screens/RoundUps/Sections/RoundUpChart.dart';
import 'package:penny/Screens/mainScreen/Screens/RoundUps/Sections/Transactions.dart';

class RoundUpsScreen extends StatelessWidget {
  const RoundUpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          RoundUpsChart(),
          SizedBox(height: 20),
          QuickActions(),
          SizedBox(height: 20),
          RoundUpsBody(),
        ],
      ),
    );
  }
}
