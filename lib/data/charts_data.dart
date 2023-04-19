import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class ChartsData {
  final String day;
  final int weight;
  final charts.Color barColor;

  ChartsData(
    {
      required this.day,
      required this.weight,
      required this.barColor
    }
  );
}
