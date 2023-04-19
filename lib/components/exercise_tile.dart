import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

   ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.weight,
      required this.reps,
      required this.sets,
      required this.isCompleted,
      required this.onCheckBoxChanged,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      color: Colors.grey[200],
      child: ListTile(
        title: Text(exerciseName),
        subtitle: Row(
          children: [
            Chip(
              label: Text('$weight 斤'),
            ),
            const SizedBox(width: 10,),
            Chip(label: Text('$reps 次'),),
            const SizedBox(width: 10,),
            Chip(label: Text('$sets 组'),),
          ],
        ),
        trailing: Checkbox(value: isCompleted, onChanged:(value) => onCheckBoxChanged!(value),),
      ),
    );
  }
}
