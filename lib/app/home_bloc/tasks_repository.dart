import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firestore_database.dart';

class TasksRepository {
  final Database database = Database();
  final String uid;
  TasksRepository({required this.uid});

  saveTasks(uid, List<TaskModel> tasks) {
    database.saveTasks(uid, tasks);
  }

  Future<List<TaskModel>?> getTasks(String uid) async {
    try {
      final List<TaskModel> tasks = await database.getTask(uid);
      return tasks;
    } catch (e) {
      return null;
    }
  }

  isToday(DateTime dateTime) {
    final nowDate = DateTime.now();
    if (dateTime.day == nowDate.day &&
        dateTime.year == nowDate.year &&
        dateTime.month == nowDate.month) {
      return true;
    } else {
      return false;
    }
  }
}
