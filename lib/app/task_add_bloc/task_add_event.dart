import 'package:todo_app/models/task_model.dart';

abstract class TaskAddPageEvents {
  const TaskAddPageEvents();
}

class TaskAddEvent extends TaskAddPageEvents {}

class TaskTitleChangeEvent extends TaskAddPageEvents {
  final String title;
  TaskTitleChangeEvent({required this.title});
}

class TaskSubTitleChangeEvent extends TaskAddPageEvents {
  final String subtitle;
  TaskSubTitleChangeEvent({required this.subtitle});
}

class TaskDateTimeChanged extends TaskAddPageEvents {
  final DateTime dateTime;
  TaskDateTimeChanged({required this.dateTime});
}
