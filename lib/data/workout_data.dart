import 'package:flutter/material.dart';
import 'package:flutter_fitness_record/data/hive_database.dart';
import 'package:flutter_fitness_record/datetime/date_time.dart';
import 'package:flutter_fitness_record/models/exercise.dart';
import 'package:flutter_fitness_record/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutList = [
    Workout(
      name: "全身运动",
      exercises: [
      ],
    ),
    
  ];

  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFormDataBase();
    } else {
      db.saveToDatabase(workoutList);
    }
    loadHeadMap();
  }

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  int numberOfExerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(Exercise(
      name: exerciseName,
      weight: weight,
      reps: reps,
      sets: sets,
    ));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveToDatabase(workoutList);
    loadHeadMap();
  }

  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  String getStartDate() {
    return db.getStartDate();
  }

Map<DateTime, int> headMapDataSet = {};

  void loadHeadMap() {
    DateTime startDate = createDateTimeObject(getStartDate());
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    for (var i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeYYYYMMDD(startDate.add(Duration(days: i)));
      int completionStatus = db.getCompletionStatus(yyyymmdd);
      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;
      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };
      headMapDataSet.addEntries(percentForEachDay.entries);
      
    }
  }
}
