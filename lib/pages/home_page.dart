import 'package:flutter/material.dart';
import 'package:flutter_fitness_record/data/workout_data.dart';
import 'package:flutter_fitness_record/models/workout.dart';
import 'package:flutter_fitness_record/pages/workout_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWrokoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new workout"),
        content: TextField(
          controller: newWrokoutNameController,
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text("save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text("cancel"),
          ),
        ],
      ),
    );
  }

  void save() {
    String newWorkoutName = newWrokoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWrokoutNameController.clear();
  }

  void goToWorkoutpage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Workout tracker'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getWorkoutList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(
                onPressed: () =>
                    goToWorkoutpage(value.getWorkoutList()[index].name),
                icon: Icon(Icons.arrow_forward_ios)),
          ),
        ),
      ),
    );
  }
}
