import 'package:flutter/material.dart';
import 'package:flutter_fitness_record/components/heat_map.dart';
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
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  final newWrokoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("创建新的锻炼"),
        content: TextField(
          controller: newWrokoutNameController,
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text("保存"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text("取消"),
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
      ),
    );
  }

final data = List.generate(128, (i) => Color(0xFFFF00FF - 2 * i));

Container _buildItem() => Container(
        alignment: Alignment.center,
        width: 100,
        height: 30,
        color: Colors.red,
        child: Text(
          "1",
          style: TextStyle(color: Colors.white, shadows: [
            Shadow(color: Colors.black, offset: Offset(.5, .5), blurRadius: 2)
          ]),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('坚持锻炼,永驻青春'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        // body: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),padding: EdgeInsets.symmetric(vertical: 5),children: data.map((e) => _buildItem()).toList(),
        body: ListView(
          children: [
            MyHeatMap(
                startDateYYYYMMDD: value.getStartDate(),
                datasets: value.headMapDataSet),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => ListTile(
                title: Text(value.getWorkoutList()[index].name),
                trailing: IconButton(
                    onPressed: () =>
                        goToWorkoutpage(value.getWorkoutList()[index].name),
                    icon: const Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ],
        ),
    ),
    );
  }


}
/**
 * 
 */