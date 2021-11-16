import 'package:todo_app/models/task_model.dart';

abstract class TaskEvent {}

class TaskLoadingEvent extends TaskEvent {}

class TaskDeleteEvent extends TaskEvent {
  int index;
  TaskDeleteEvent({required this.index});
}

class TaskCompleteEvent extends TaskEvent {
  int index;
  TaskCompleteEvent({required this.index});
}

class TaskOpenEvent extends TaskEvent {}

class TaskModeChangeEvent extends TaskEvent {
  TasksMode tasksMode;
  TaskModeChangeEvent({required this.tasksMode});
}

class TaskChangedEvent extends TaskEvent {
  final List<TaskModel> tasks;
  TaskChangedEvent({required this.tasks});
}

enum TasksMode { completedTasks, allTasks, noCompletedtasks, tasksForToday }
