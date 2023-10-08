// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_do_list/main.dart';
import 'package:to_do_list/model/task.dart';
import 'package:to_do_list/presentation/task_cubit.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  group("BLoC tests for the task cubit.", () {
    final task = Task(text: "First task");

    blocTest<TaskCubit, TaskState>(
      'emits [TaskUpdated] when addOneTask is called.',
      seed: () => TaskInitial(),
      build: () => TaskCubit(),
      act: (cubit) => cubit.addOneTask(task),
      expect: () => <TaskState>[
        TaskUpdated(tasks: <Task>[task])
      ],
    );

    final secondTask = Task(text: "Second task");

    blocTest<TaskCubit, TaskState>(
      'given a TaskUpdated with one task, emits [TaskUpdated] when addOneTask is called.',
      seed: () => TaskUpdated(tasks: [task]),
      build: () => TaskCubit(),
      act: (cubit) => cubit.addOneTask(secondTask),
      expect: () => <TaskState>[
        TaskUpdated(tasks: [task, secondTask])
      ],
    );

    blocTest<TaskCubit, TaskState>(
      'emits [TaskUpdated] when completeOneTask is added.',
      seed: () => TaskUpdated(
          tasks: [Task(text: "1"), Task(text: "2"), Task(text: "3")]),
      build: () => TaskCubit(),
      act: (cubit) => cubit.completeOneTask(Task(text: "2")),
      expect: () => <TaskState>[
        TaskUpdated(tasks: [
          Task(text: "1"),
          Task(text: "2", isDone: true),
          Task(text: "3")
        ])
      ],
    );

    blocTest<TaskCubit, TaskState>(
      'Given a TaskInitial, emits [] when completeOneTask is added.',
      seed: () => TaskInitial(),
      build: () => TaskCubit(),
      act: (cubit) => cubit.completeOneTask(Task(text: "2")),
      expect: () => <TaskState>[],
    );

    blocTest<TaskCubit, TaskState>(
      'Given a TaskUpdated with 0 task, emits [] when completeOneTask is added.',
      seed: () => TaskUpdated(tasks: []),
      build: () => TaskCubit(),
      act: (cubit) => cubit.completeOneTask(Task(text: "2")),
      expect: () => <TaskState>[],
    );
  });
}
