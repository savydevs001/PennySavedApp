import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RoundUpsChart extends StatelessWidget {
  const RoundUpsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF292B3E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$22,859',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'This Year',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '+29%',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Total Round-Up Contributions',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barGroups: [
                  makeGroupData(0, 8, Color.fromRGBO(133, 187, 101, 0.16)),
                  makeGroupData(1, 18, Color.fromRGBO(133, 187, 101, 1)),
                  makeGroupData(2, 12, Color.fromRGBO(133, 187, 101, 0.16)),
                  makeGroupData(3, 14, Color.fromRGBO(133, 187, 101, 0.16)),
                ],
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style =
                            TextStyle(color: Colors.white54, fontSize: 12);
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Jan - Mar', style: style);
                          case 1:
                            return const Text('Apr - Jun', style: style);
                          case 2:
                            return const Text('Jul - Sep', style: style);
                          case 3:
                            return const Text('Oct - Dec', style: style);
                          default:
                            return const Text('', style: style);
                        }
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BarChartGroupData makeGroupData(int x, double y, Color color) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        borderRadius: BorderRadius.circular(8),
        width: 20,
      ),
    ],
  );
}
