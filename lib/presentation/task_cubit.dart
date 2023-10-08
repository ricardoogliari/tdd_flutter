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
}