import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String title;
  String subtitle;
  bool isCompleted;
  DateTime deadLine;
  DateTime addDate;
  TaskModel({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.deadLine,
    required this.addDate,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
      'deadLine': deadLine,
      'addDate': addDate,
    };
  }

  factory TaskModel.toTaskModel(Map<String, dynamic> map) {
    return TaskModel(
        title: map['title'],
        subtitle: map['subtitle'],
        isCompleted: map['isCompleted'],
        deadLine: DateTime.fromMillisecondsSinceEpoch(
            (map['deadLine'] as Timestamp).millisecondsSinceEpoch),
        addDate: DateTime.fromMillisecondsSinceEpoch(
            (map['addDate'] as Timestamp).millisecondsSinceEpoch));
  }
}

class TasksForToday {
  TaskModel task;
  int index;
  TasksForToday({required this.task, required this.index});
}
