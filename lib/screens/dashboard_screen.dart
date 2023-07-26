import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

import '../helpers/sql_account_helper.dart';
import '../helpers/sql_note_helper.dart';

// ignore: must_be_immutable
class DashboardForm extends StatefulWidget {

  DashboardForm({super.key});

  @override
  State<DashboardForm> createState() => _DashboardFormState();
}

class _DashboardFormState extends State<DashboardForm> {
  final int? _idAccount = SQLAccountHelper.currentAccount['id'];
  List<Map<String, dynamic>> noteList = [];

  Future<void> _loadNotes() async {
    final data = await SQLNoteHelper.getNotes(accountId: _idAccount);

    setState(() {
      noteList = data;
    });
  }

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


