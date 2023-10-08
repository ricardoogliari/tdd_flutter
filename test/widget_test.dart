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
import 'package:to_do_list/task_cell.dart';

void main() {
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

    blocTest<TaskCubit, TaskState>(
      'Given a TaskUpdated with 3 tasks, emits [TaskUpdated] when deleteOneTask is called, with a task contained in the list.',
      seed: () => TaskUpdated(
          tasks: [Task(text: "1"), Task(text: "2"), Task(text: "3")]),
      build: () => TaskCubit(),
      act: (cubit) => cubit.deleteOneTask(Task(text: "1")),
      expect: () => <TaskState>[
        TaskUpdated(tasks: [Task(text: "2"), Task(text: "3")])
      ],
    );

    blocTest<TaskCubit, TaskState>(
      'Given a TaskInitial, emits [TaskUpdated] when deleteOneTask is called.',
      seed: () => TaskInitial(),
      build: () => TaskCubit(),
      act: (cubit) => cubit.deleteOneTask(Task(text: "1")),
      expect: () => <TaskState>[],
    );

    blocTest<TaskCubit, TaskState>(
      'Given a TaskUpdated with 3 tasks, emits [TaskUpdated] when deleteOneTask is called, with a task is NOT contained in the list.',
      seed: () => TaskUpdated(
          tasks: [Task(text: "0"), Task(text: "2"), Task(text: "3")]),
      build: () => TaskCubit(),
      act: (cubit) => cubit.deleteOneTask(Task(text: "1")),
      expect: () => <TaskState>[],
    );
  });

  group("Adding one task", () {
    testWidgets(
      "Find a TextField, enter text in it, and find a button with text 'Add', and then tap it to find a new TaskCell created.",
          (tester) async {
        await tester.pumpWidget(MyApp());

        final textField = find.byType(TextField);
        final taskText = "Finish Widget tests";

        expect(textField, findsOneWidget);
        expect(find.byType(TaskCell), findsNothing);
        await tester.enterText(textField, taskText);
        await tester.tap(find.text("Add task"));

        await tester.pumpAndSettle();

        expect(find.byType(TaskCell), findsOneWidget);
      },
    );

    testWidgets(
      "Find a TextField, enter text in it, and find a button with text 'Add', and then tap it to verify if the TextField has been emptied.",
          (tester) async {
        await tester.pumpWidget(MyApp());

        final textField = find.byType(TextField);
        final taskText = "Finish Widget tests";

        // Textfield should be empty
        expect(
            (textField.evaluate().first.widget as TextField).controller == null,
            false);
        expect(
          (textField.evaluate().first.widget as TextField).controller?.text ??
            "Not empty",
            "",
        );

        expect(textField, findsOneWidget);
        expect(find.byType(TaskCell), findsNothing);
        await tester.enterText(textField, taskText);

        // TextField should not be empty.
        expect(
          (textField.evaluate().first.widget as TextField).controller?.text ??
              "Not empty",
          taskText,
        );
        await tester.tap(find.text("Add task"));

        await tester.pumpAndSettle();

        // TextField should have been emptied.
        expect(
          (textField.evaluate().first.widget as TextField).controller?.text ??
              "Not empty",
          "",
        );
      },
    );
  });

  group("Complete one task", () {
    testWidgets("Complete one task, and verify that the correct icon is showed",
            (tester) async {
          final taskText = "Finish test widgets";

          await _addTask(tester, taskText: taskText);

          final taskCell = find.byType(TaskCell);
          expect(taskCell, findsOneWidget);

          expect(find.byType(IconButton), findsOneWidget);
          expect(find.byIcon(Icons.circle), findsOneWidget);

          await tester.tap(find.byType(IconButton));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.check), findsOneWidget);
          expect(
            taskCell.accessFirstWidgetAs<TaskCell>().task,
            Task(text: taskText, isDone: true),
          );
        });
  });
}

Future<void> _addTask(
    WidgetTester tester, {
      String taskText = "Finish Widget tests",
    }) async {
  await tester.pumpWidget(MyApp());

  final textField = find.byType(TextField);

  expect(textField, findsOneWidget);
  expect(find.byType(TaskCell), findsNothing);
  await tester.enterText(textField, taskText);
  await tester.tap(find.text("Add task"));

  await tester.pumpAndSettle();
}

extension FinderExtension on Finder {
  Widget accessFirstWidget() => evaluate().first.widget;
  E accessFirstWidgetAs<E extends Widget>() => accessFirstWidget() as E;
}
