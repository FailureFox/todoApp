import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/auth_bloc/auth_repository.dart';
import 'package:todo_app/app/auth_bloc/form_status.dart';
import 'package:todo_app/app/auth_bloc/login_bloc/login_event.dart';
import 'package:todo_app/app/auth_bloc/login_bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginState());
  @override
  Stream<LoginState> mapEventToState(LoginEvents event) async* {
    if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is LoginPasswordConfirimChanged) {
      yield state.copyWith(confirimPassword: event.password);
    } else if (event is LoginChangeType) {
      yield state.copyWith(isLogin: event.loginType);
    } else if (event is LoginSubmit) {
      yield state.copyWith(formStatus: FormSubmittion());

      if (state.isLogin) {
        try {
          final user = await authRepository.loginWithEMalAndPassword(
              state.email, state.password);
          yield state.copyWith(formStatus: FormSubmittionSuccessForLogin(user: user));
        } catch (error) {
          yield state.copyWith(
              formStatus: FormSubmittionError(error: Exception(error)));
          yield state.copyWith(formStatus: const FormInitialStatus());
        }
      } else {
        try {
          final user = await authRepository.regitrationWithEmailAndPassword(
              state.email, state.password);
          yield state.copyWith(formStatus: FormSubmittionSuccessForLogin(user: user));
        } catch (error) {
          state.copyWith(
              formStatus: FormSubmittionError(error: Exception(error)));
        }
      }
    }
  }
}
