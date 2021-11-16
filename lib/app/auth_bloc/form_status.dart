import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task_model.dart';

abstract class FormSubmittionStatus {
  const FormSubmittionStatus();
}

class FormInitialStatus extends FormSubmittionStatus {
  const FormInitialStatus();
}

class FormSubmittion extends FormSubmittionStatus {}

class FormSubmittionSuccessForLogin extends FormSubmittionStatus {
  final UserCredential user;
  FormSubmittionSuccessForLogin({required this.user});
}

class FormSubmittionError extends FormSubmittionStatus {
  Exception error;
  get geterror => error;
  FormSubmittionError({required this.error});
}

class FormSubmittionSuccessForTask {
  final TaskModel task;
  FormSubmittionSuccessForTask({required this.task});
}
