import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PortfolioPerformance extends StatelessWidget {
  const PortfolioPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(47, 43, 61, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text("Portfolio Performance",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              Text("This week ")
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("\$22,859",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(105, 245, 109, 0.2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 4, left: 4, top: 2, bottom: 2),
                    child: Text("+29%",
                        style: TextStyle(
                            color: const Color.fromRGBO(76, 175, 80, 1),
                            fontSize: 15)),
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 20),
          const Text(
            "Your portfolio’s value increased by 29% this month!",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w300, color: Colors.white),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                barGroups: [
                  _buildBarGroup(0, 4),
                  _buildBarGroup(1, 7),
                  _buildBarGroup(2, 6),
                  _buildBarGroup(3, 5),
                  _buildBarGroup(4, 10, const Color.fromRGBO(133, 187, 101, 1)),
                  _buildBarGroup(5, 6),
                  _buildBarGroup(6, 5),
                ],
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true, getTitlesWidget: _bottomTitlesWeek),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
              ),
            ),
          ), // Placeholder for chart
        ],
      ),
    );
  }
}

Widget _bottomTitlesWeek(double value, TitleMeta meta) {
  const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child:
        Text(days[value.toInt()], style: const TextStyle(color: Colors.white)),
  );
}

class PortfolioList extends StatelessWidget {
  final List<Map<String, dynamic>> stocks = [
    {
      "name": "Spotify",
      "price": "\$154.01",
      "change": "+25.8%",
      "color": const Color.fromRGBO(133, 187, 101, 1)
    },
    {
      "name": "Apple",
      "price": "\$145.86",
      "change": "-1.2%",
      "color": Colors.red
    },
    {
      "name": "Amazon",
      "price": "\$3,372.20",
      "change": "-0.15%",
      "color": Colors.red
    },
    {
      "name": "Google",
      "price": "\$2,739.53",
      "change": "-0.5%",
      "color": Colors.red
    },
    {
      "name": "Microsoft",
      "price": "\$286.14",
      "change": "+2.8%",
      "color": const Color.fromRGBO(133, 187, 101, 1)
    },
  ];

  PortfolioList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(47, 43, 61, 1),
                borderRadius: BorderRadius.circular(5)),
            child: Card(
              color: const Color.fromRGBO(21, 20, 27, 0.537),
              child: ListTile(
                title: Text(stocks[index]["name"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14)),
                subtitle: Text(
                  stocks[index]["price"],
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  stocks[index]["change"],
                  style: TextStyle(color: stocks[index]["color"]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

BarChartGroupData _buildBarGroup(int x, double y,
    [Color color = const Color.fromRGBO(133, 187, 101, 0.16)]) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        width: 20,
        borderRadius: BorderRadius.circular(8),
      ),
    ],
  );
}
