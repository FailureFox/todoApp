abstract class TaskStatus {
  const TaskStatus();
}

class TaskInitialStatus extends TaskStatus {
  const TaskInitialStatus();
}

class TaskLoadingStatus extends TaskStatus {}

class TaskLoadingSuccess extends TaskStatus {}

class TaskLoadingError extends TaskStatus {
  Exception error;
  TaskLoadingError({required this.error});
}
