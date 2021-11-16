import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/home_bloc/tasks_repository.dart';
import 'package:todo_app/app/task_add_bloc/task_add_event.dart';
import 'package:todo_app/app/task_add_bloc/task_add_state.dart';
import 'package:todo_app/models/task_model.dart';

class TaskAddBloc extends Bloc<TaskAddPageEvents, TaskAddState> {
  final TasksRepository taskRepository;
  TaskAddBloc({required this.taskRepository})
      : super(TaskAddState(dateTime: DateTime.now()));

  @override
  Stream<TaskAddState> mapEventToState(TaskAddPageEvents event) async* {
    if (event is TaskAddEvent) {
      final List<TaskModel> taskmodel =
          await taskRepository.getTasks(taskRepository.uid) ?? [];

      taskmodel.add(TaskModel(
          title: state.title,
          subtitle: state.subTitle,
          isCompleted: false,
          deadLine: state.dateTime,
          addDate: DateTime.now()));
      await taskRepository.saveTasks(taskRepository.uid, taskmodel);
    } else if (event is TaskTitleChangeEvent) {
      yield state.copyWith(title: event.title);
    } else if (event is TaskSubTitleChangeEvent) {
      yield state.copyWith(subTitle: event.subtitle);
    } else if (event is TaskDateTimeChanged) {
      yield state.copyWith(dateTime: event.dateTime);
    }
  }
}
