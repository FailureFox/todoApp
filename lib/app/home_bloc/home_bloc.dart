import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/home_bloc/home_event.dart';
import 'package:todo_app/app/home_bloc/home_state.dart';
import 'package:todo_app/app/home_bloc/tasks_repository.dart';
import 'package:todo_app/app/home_bloc/tasks_status.dart';
import 'package:todo_app/models/task_model.dart';

class TasksBloc extends Bloc<TaskEvent, TaskState> {
  final TasksRepository taskRepository;
  TasksBloc({required this.taskRepository}) : super(TaskState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is TaskLoadingEvent) {
      yield state.copyWith(status: TaskLoadingStatus());
      try {
        final List<TaskModel> tasks =
            await taskRepository.getTasks(taskRepository.uid) ?? [];
        yield state.copyWith(tasks: tasks, status: TaskLoadingSuccess());
      } catch (e) {
        yield state.copyWith(status: TaskLoadingError(error: Exception(e)));
      }
    } else if (event is TaskDeleteEvent) {
      state.tasks.removeAt(event.index);
      taskRepository.saveTasks(taskRepository.uid, state.tasks);
      yield state.copyWith(tasks: state.tasks);
    } else if (event is TaskCompleteEvent) {
      state.tasks[event.index].isCompleted = true;
      taskRepository.saveTasks(taskRepository.uid, state.tasks);
      yield state.copyWith(tasks: state.tasks);
    } else if (event is TaskModeChangeEvent) {
      yield state.copyWith(taskMode: event.tasksMode);
    } else if (event is TaskChangedEvent) {
      yield state.copyWith(tasks: event.tasks);
    }
  }
}
