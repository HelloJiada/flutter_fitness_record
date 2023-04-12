import 'package:flutter/material.dart';
import 'package:flutter_fitness_record/data/workout_data.dart';
import 'package:flutter_fitness_record/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
