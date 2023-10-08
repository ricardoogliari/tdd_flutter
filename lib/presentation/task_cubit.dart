import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_list/model/task.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  addOneTask(Task task) {
    if (state is TaskInitial) {
      emit(TaskUpdated(tasks: [task]));
    } else if (state is TaskUpdated) {
      emit(TaskUpdated(tasks: [...(state as TaskUpdated).tasks, task]));
    }
  }

  completeOneTask(Task task) {
    if (state is TaskUpdated) {
      final tasks = [...(state as TaskUpdated).tasks];

      final index = tasks.indexWhere((element) => element.text == task.text);

      tasks.removeAt(index);
      tasks.insert(index, task.copyWith(isDone: true));

      emit(TaskUpdated(tasks: tasks));
    }
  }
}