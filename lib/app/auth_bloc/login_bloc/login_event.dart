abstract class LoginEvents {}

class LoginEmailChanged extends LoginEvents {
 final String email;
  LoginEmailChanged({required this.email});
}

class LoginPasswordChanged extends LoginEvents {
 final String password;
  LoginPasswordChanged({required this.password});
}

class LoginPasswordConfirimChanged extends LoginEvents {
 final String password;
  LoginPasswordConfirimChanged({required this.password});
}

class LoginChangeType extends LoginEvents {
 final bool loginType;
  LoginChangeType({required this.loginType});
}

class LoginSubmit extends LoginEvents {}
