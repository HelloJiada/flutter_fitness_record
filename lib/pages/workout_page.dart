// import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitness_record/components/exercise_tile.dart';
import 'package:flutter_fitness_record/components/show_alert_dialog.dart';
import 'package:flutter_fitness_record/data/workout_data.dart';
import 'package:flutter_fitness_record/pages/charts_page.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onChackBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExerdise() {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加一个新练习'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.auto_fix_normal_outlined),
                  hintText: '请输入运动名称',
                  labelText: '运动名称'),
              controller: exerciseNameController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.monitor_weight),
                  hintText: '请输入体重(斤)',
                  labelText: '体重(斤)'),
              controller: weightController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.accessibility_new),
                  hintText: '请输入次数(次)',
                  labelText: '次数(次)'),
              controller: repsController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.addchart_sharp),
                hintText: '请输入组数(组)',
                labelText: '组数(组)',
              ),
              controller: setsController,
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: save,
            child: const Text('保存'),
            
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void save() {
    String exerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    if (exerciseName.length > 20) {
      return showAlertDialog(context: context, message: '运动名称过长');
    }
    if (weight.length > 3) {
      return showAlertDialog(context: context, message: '体重过大,60-999斤');
    }
    if (reps.length > 3) {
      return showAlertDialog(context: context, message: '次数过多,1-999次');
    }
    if (sets.length > 3) {
      return showAlertDialog(context: context, message: '组数过多,1-999组');
    }

    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, exerciseName, weight, reps, sets);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExerdise,
          child: const Icon(Icons.add),
        ),
        body: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChartsPage(exercises: value.getRelevantWorkout(widget.workoutName).exercises,),
            ),
          ),
          child: ListView.builder(
            itemCount:
                value.getRelevantWorkout(widget.workoutName).exercises.length,
            itemBuilder: (context, index) => ExerciseTile(
              exerciseName: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .name,
              weight: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .weight,
              reps: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .reps,
              sets: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .sets,
              isCompleted: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .isCompleted,
              onCheckBoxChanged: (val) => onChackBoxChanged(
                  widget.workoutName,
                  value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name),
            ),
          ),
        ),
      ),
    );
  }
}
