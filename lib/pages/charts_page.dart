import 'dart:math';
import 'package:flutter/material.dart';
import '../data/charts_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/exercise.dart';
import '../pages/charts_page.dart';
import '../models/charts_series.dart';

final _random = Random();
int next(int min, int max) {
  var result = min + _random.nextInt(max - min);
  return result;
}

final List<ChartsData> data = [];
fetchAllImage() {
  for (var i = 0; i < 7; i++) {
    var c = next(50, 100);
    data.add(
      ChartsData(
        day: "$i",
        weight: c,
        barColor: charts.ColorUtil.fromDartColor(
          Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
              Random().nextInt(256), 1),
        ),
      ),
    );
  }
}

class ChartsPage extends StatefulWidget {

  final List<Exercise> exercises;
  
  const ChartsPage({super.key, required this.exercises,});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("指标数据"),
      ),
      body: ChartsSeries(data: data),
    );
  }
}
