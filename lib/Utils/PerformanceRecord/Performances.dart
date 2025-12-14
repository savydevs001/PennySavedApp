import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Services/api_service.dart';
import '../api_config.dart';
import '../../Providers/app_state.dart';
import '../../Services/auth_service.dart';

class PortfolioPerformance extends StatefulWidget {
  const PortfolioPerformance({super.key});

  @override
  State<PortfolioPerformance> createState() => _PortfolioPerformanceState();
}

class _PortfolioPerformanceState extends State<PortfolioPerformance> {
  final ApiService _api = ApiService(baseUrl: ApiConfig.baseUrl);
  bool _isLoading = false;
  num _totalInvestment = 0;
  num _portfolioValue = 0;
  num _profitLoss = 0;
  num _percentChange = 0;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final token = await AuthService().getToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';
      final response = await _api.get(ApiConfig.marketStats, headers: headers);
      if (response is Map) {
        setState(() {
          _totalInvestment = (response['totalInvestment'] is num)
              ? response['totalInvestment']
              : (num.tryParse(response['totalInvestment']?.toString() ?? '') ?? 0);
          _portfolioValue = (response['portfolioValue'] is num)
              ? response['portfolioValue']
              : (num.tryParse(response['portfolioValue']?.toString() ?? '') ?? 0);
          _profitLoss = (response['profitLoss'] is num)
              ? response['profitLoss']
              : (num.tryParse(response['profitLoss']?.toString() ?? '') ?? 0);
          _percentChange = (response['percentChange'] is num)
              ? response['percentChange']
              : (num.tryParse(response['percentChange']?.toString() ?? '') ?? 0);
        });
        //prin the fetched values and their types
        print('Fetched market stats: totalInvestment=$_totalInvestment (${_totalInvestment.runtimeType}),portfolioValue=$_portfolioValue (${_portfolioValue.runtimeType}),profitLoss=$_profitLoss (${_profitLoss.runtimeType}),percentChange=$_percentChange (${_percentChange.runtimeType})');

        //set the Appstate value for all these values too
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setTotalInvestment(_totalInvestment.ceil());
        appState.setPortfolioValue(_portfolioValue as double);
        appState.setProfitLoss(_profitLoss as double);
        appState.setPercentChange(_percentChange as double);
      }
    } catch (e) {
      print('Error fetching market stats: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _profitColor(num value) => value >= 0 ? const Color.fromRGBO(76, 175, 80, 1) : Colors.red;
//make the popup card for invest and earn
Widget _buildInvestPopup(BuildContext context) {
  final TextEditingController _amountController = TextEditingController();
  //make the alert dialog color and style as per app theme
  return AlertDialog(
    backgroundColor: const Color.fromRGBO(47, 43, 61, 1),
    title: const Text(
      'Invest & Earn',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    content: TextField(
      controller: _amountController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Amount to Invest',
        labelStyle: const TextStyle(color: Colors.white60),
        hintText: 'Enter amount less than wallet balance',
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color.fromRGBO(34, 33, 40, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
      ),
      ElevatedButton(
        onPressed: () async {
          final amountText = _amountController.text.trim();
          final amount = num.tryParse(amountText);
          if (amount == null || amount <= 0) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
            }
            return;
          }
          try {
            final token = await AuthService().getToken();
            Map<String, String> headers = {'Content-Type': 'application/json'};
            if (token != null) headers['Authorization'] = 'Bearer $token';

            final resp = await _api.post(ApiConfig.marketInvest, {'amount': amount}, headers: headers);
            final msg = (resp is Map && resp['message'] != null) ? resp['message'].toString() : 'Investment successful';
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              Navigator.of(context).pop();
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Investment failed: $e')));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(133, 187, 101, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Invest', style: TextStyle(color: Colors.white)),
      ),
    ],
  );
}
  @override
  Widget build(BuildContext context) {
    final walletBalance = Provider.of<AppState>(context).walletBalance;
    final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);
    final percentFormatter = NumberFormat('##0.00');

    return Container(
      padding: const EdgeInsets.all(5.0),
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
            ],
          ),
          const SizedBox(height: 12),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full-width Card: Total Investment
                    _StatCard(
                      title: 'Total Investment',
                      amount: currencyFormatter.format(_totalInvestment),
                      percentText:
                          '${_percentChange >= 0 ? '+' : ''}${percentFormatter.format(_percentChange)}%'.replaceAll('NaN%', ''),
                      percentColor: _profitColor(_percentChange),
                                                  secondary: Text(
                              '${_profitLoss >= 0 ? '+' : '-'}${currencyFormatter.format(_profitLoss.abs())}',
                              style: TextStyle(color: _profitColor(_profitLoss)),
                            ),
                      subtitle: 'Profit/Loss',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Total Investment tapped')));
                      },
                    ),
                    const SizedBox(height: 12),
                    // Bottom cards: Wallet Balance and Portfolio Value
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Wallet Balance',
                            amount: currencyFormatter.format(walletBalance),
                            action: 'Invest & Earn',
                            onActionPressed: () {
                              //when user clicks on invest and earn, show them a popup inputting amount to invest should be less than wallet balance
                              //once they input amount call '/market/invest' with payload {amount: the amount}, show snackbar saying teh res[''message']
                              showDialog(
                                context: context,
                                builder: (context) => _buildInvestPopup(context),
                              );

                              //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invest & Earn pressed')));
                            },
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet card tapped')));
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Portfolio Value',
                            amount: currencyFormatter.format(_portfolioValue),
                            percentText:
                                '${_percentChange >= 0 ? '+' : ''}${percentFormatter.format(_percentChange)}%'.replaceAll('NaN%', ''),
                            percentColor: _profitColor(_percentChange),
                            action: 'View Details',
                            onActionPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('View details pressed')));
                            },
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Portfolio card tapped')));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          // Keep list if desired
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// Small card used to display each stat
class _StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final String? subtitle;
  final String? percentText;
  final Color? percentColor;
  final Widget? secondary;
  final String? action;
  final VoidCallback? onActionPressed;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.amount,
    this.subtitle,
    this.percentText,
    this.percentColor,
    this.secondary,
    this.action,
    this.onActionPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(34, 33, 40, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amount,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              if (percentText != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: (percentColor ?? Colors.green).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(percentText ?? '',
                      style: TextStyle(color: percentColor ?? Colors.green)),
                )
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: const TextStyle(color: Colors.white38))
          ],
          if (secondary != null) ...[
            const SizedBox(height: 8),
            secondary!,
          ],
          const SizedBox(height: 12),
          if (action != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(133, 187, 101, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: Text(action!, style: const TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    ));
  }
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

// previous chart helpers were removed when switching to the simpler display
