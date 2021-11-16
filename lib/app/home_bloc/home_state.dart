import 'package:todo_app/app/home_bloc/tasks_status.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firestore_database.dart';
import 'home_event.dart';

class TaskState {
  TaskStatus status;
  List<TaskModel> tasks;
  TasksMode taskMode;
  final Database dataBase = Database();

  get tasksLenght => tasks.length;
  int completedTasksLenght() {
    int lenght = 0;
    for (var task in tasks) {
      task.isCompleted == true ? lenght++ : null;
    }
    return lenght;
  }

  double getprogress() => (completedTasksLenght() * 100) / tasksLenght;

  TaskState({
    this.status = const TaskInitialStatus(),
    this.tasks = const [],
    this.taskMode = TasksMode.tasksForToday,
  });

  TaskState copyWith({
    TaskStatus? status,
    List<TaskModel>? tasks,
    TasksMode? taskMode,
  }) {
    return TaskState(
        status: status ?? this.status,
        tasks: tasks ?? this.tasks,
        taskMode: taskMode ?? this.taskMode);
  }
}
