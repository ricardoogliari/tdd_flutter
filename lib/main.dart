import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/model/task.dart';
import 'package:to_do_list/presentation/task_cubit.dart';
import 'package:to_do_list/task_cell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter todo list using TDD',
      home: Scaffold(
        appBar: AppBar(
          title: Text("ToDo List"),
        ),
        body: BlocProvider(
          create: (context) => TaskCubit(),
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          AddTaskSection(),
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
              if (state is TaskUpdated) {
                return ListView(
                  children: state.tasks.mapToList(
                        (task) => Dismissible(
                      key: Key(task.text),
                      child: TaskCell(task: task),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          context.read<TaskCubit>().deleteOneTask(task);
                        }
                      },
                    ),
                  ),
                );
              }

              return Container();
            }),
          )
        ],
      ),
    );
  }
}

extension ListExtension<E> on Iterable<E> {
  List<T> mapToList<T>(T Function(E) mapper) => map(mapper).toList();
}

class AddTaskSection extends StatelessWidget {
  const AddTaskSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter your task..."),
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<TaskCubit>().addOneTask(Task(text: controller.text));
            controller.text = "";
          },
          child: Text("Add task"),
        )
      ],
    );
  }
}