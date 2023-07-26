import 'package:mock_prj1/helpers/sql_account_helper.dart';
import 'package:mock_prj1/helpers/sql_note_helper.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DashboardForm extends StatefulWidget {
  DashboardForm({super.key});

  @override
  State<DashboardForm> createState() => _DashboardFormState();
}

class _DashboardFormState extends State<DashboardForm> {
  late Map<String, double> _dataMap;
  bool _isLoading = true;

  Future<void> _refreshCharts() async {
    final data =
        await SQLNoteHelper.getStat(SQLAccountHelper.currentAccount['id']);

    setState(() {
      _dataMap = data;
      _isLoading = false;
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _refreshCharts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : Container(
        child: Center(
          child: PieChart(
            dataMap: _dataMap,
            chartRadius: MediaQuery.of(context).size.width / 1.7,
            legendOptions:
                const LegendOptions(legendPosition: LegendPosition.bottom),
            chartValuesOptions:
                const ChartValuesOptions(showChartValuesInPercentage: true),
          ),
        ),
      ),
    );
  }
}