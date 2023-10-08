import 'package:flutter/material.dart';
import 'package:to_do_list/model/task.dart';

class TaskCell extends StatelessWidget {
  final Task task;

  const TaskCell({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Text(task.text);
  }
}