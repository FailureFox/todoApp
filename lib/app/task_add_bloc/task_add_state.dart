import 'package:todo_app/app/auth_bloc/form_status.dart';

class TaskAddState {
  final String title;
  final String subTitle;
  final FormSubmittionStatus status;
  DateTime dateTime = DateTime.now();
  TaskAddState({
    this.title = '',
    this.subTitle = '',
    this.status = const FormInitialStatus(),
    required this.dateTime,
  });
  TaskAddState copyWith(
      {String? title,
      String? subTitle,
      FormSubmittionStatus? status,
      DateTime? dateTime}) {
    return TaskAddState(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
