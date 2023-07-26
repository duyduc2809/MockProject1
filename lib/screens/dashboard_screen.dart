import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DashboardForm extends StatefulWidget {

  DashboardForm({super.key});

  @override
  State<DashboardForm> createState() => _DashboardFormState();
}

class _DashboardFormState extends State<DashboardForm> {
  Map<String, double> dataMap = {
    "Pending": 7,
    "Done": 2.4,
    "Processing": 2.4,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: PieChart(
            dataMap: dataMap,
            chartRadius: MediaQuery.of(context).size.width / 1.7,
            legendOptions: const LegendOptions(
              legendPosition: LegendPosition.bottom
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true
            ),
          ),
        ),
      ),
    );
  }
}


