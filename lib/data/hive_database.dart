import 'package:flutter_fitness_record/datetime/date_time.dart';
import 'package:flutter_fitness_record/models/exercise.dart';
import 'package:hive/hive.dart';

import '../models/workout.dart';

class HiveDatabase {
  final _myBox = Hive.box("workout_database1");

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print('以前的数据不存在');
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("以前的数据存在");
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  List<Workout> readFormDataBase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutName = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (var i = 0; i < workoutName.length; i++) {
      List<Exercise> exercissInEachWorkout = [];
      for (var j = 0; j < exerciseDetails[i].length; j++) {
        exercissInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "treu" ? true : false,
          ),
        );
      }
      Workout workout = Workout(name: workoutName[i], exercises: exercissInEachWorkout);
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  bool exerciseCompleted(List<Workout> workouts) {

    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus(String yyyymmdd) {
    int completionsStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionsStatus;
  }
}

List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (var i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];
  for (var i = 0; i < workouts.length; i++) {
    List<Exercise> exerciseInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];

    for (var j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll(
        [
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].sets,
          exerciseInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
