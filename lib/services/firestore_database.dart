import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';

class Database {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('tasks');

  void saveTasks(String uid, List<TaskModel> tasks) async {
    return await _collectionReference.doc(uid).set(
      {'uid': uid, 'tasks': tasks.map((e) => e.toMap()).toList()},
    );
  }

  Future<List<TaskModel>> getTask(String uid) async {
    final document = await _collectionReference.doc(uid).get();
    List<dynamic> tasks = document['tasks'] as List<dynamic>;
    final List<TaskModel> taskModel =
        tasks.map((e) => TaskModel.toTaskModel(e)).toList();
    return taskModel;
  }
}
