import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../data/charts_data.dart';

class ChartsSeries extends StatelessWidget {


  final List<ChartsData> data;

  const ChartsSeries({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
        List<charts.Series<ChartsData, String>> series = [
      charts.Series(
        id: "developers",
        data: data,
        domainFn: (ChartsData series, _) => series.day,
        measureFn: (ChartsData series, _) => series.weight,
        colorFn: (ChartsData series, _) => series.barColor
      )
    ];
    return charts.BarChart(series, animate: true);
  }
}
