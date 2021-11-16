import 'package:todo_app/app/auth_bloc/form_status.dart';
import 'package:todo_app/services/firebase_auth.dart';

class LoginState {
  final String email;
  final String password;
  final String confirimPassword;
  final bool isLogin;
  final FormSubmittionStatus formStatus;
  final FireBaseAuthService fireBaseAuthService = FireBaseAuthService();

  get validatePassword => password.length > 7;

  get validateMail => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  get validateConfirimPassword => password == confirimPassword;

  LoginState(
      {this.email = '',
      this.password = '',
      this.confirimPassword = '',
      this.isLogin = true,
      this.formStatus = const FormInitialStatus()});

  LoginState copyWith({
    String? email,
    String? password,
    String? confirimPassword,
    bool? isLogin,
    FormSubmittionStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirimPassword: confirimPassword ?? this.confirimPassword,
      isLogin: isLogin ?? this.isLogin,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
