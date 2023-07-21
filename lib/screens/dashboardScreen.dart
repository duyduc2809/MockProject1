import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DashboardForm extends StatelessWidget {
  Map<String, double> dataMap = {
    "Pending": 7,
    "Done": 2.4,
    "Processing": 2.4,
  };

  DashboardForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Form"),
        centerTitle: true,
      ),
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


