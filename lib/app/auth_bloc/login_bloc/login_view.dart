import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/auth_bloc/auth_repository.dart';
import 'package:todo_app/app/auth_bloc/form_status.dart';
import 'package:todo_app/app/auth_bloc/login_bloc/login_bloc.dart';
import 'package:todo_app/app/auth_bloc/login_bloc/login_event.dart';
import 'package:todo_app/app/auth_bloc/login_bloc/login_state.dart';
import 'package:todo_app/app/home_bloc/home_view.dart';
import 'package:todo_app/app/auth_bloc/login_bloc/components/auth_title.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: const LoginPageWithRepository(),
    );
  }
}

class LoginPageWithRepository extends StatelessWidget {
  const LoginPageWithRepository({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          LoginBloc(authRepository: context.read<AuthRepository>()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              const AuthTitle(title: 'LogIn'),
              const Spacer(flex: 1),
              Center(
                  child: SizedBox(
                      height: 60, child: Image.asset('assets/logo.png'))),
              const SizedBox(height: 70),
              LoginForms(),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForms extends StatelessWidget {
  LoginForms({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final _formstatus = state.formStatus;
        if (_formstatus is FormSubmittionError) {
          _showSnackBar(context, _formstatus.error.toString());
        } else if (_formstatus is FormSubmittionSuccessForLogin) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        user: _formstatus.user.user!.uid,
                      )),
              (route) => false);
        }
      },
      child: ScaleTransition(
        scale: const AlwaysStoppedAnimation(0.9),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const EmailFormFiled(),
                const SizedBox(height: 10),
                const PasswordFormFiled(isConfirim: false),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  if (state.isLogin) {
                    return const SizedBox(height: 20);
                  } else {
                    return Column(
                      children: const [
                        SizedBox(height: 10),
                        PasswordFormFiled(isConfirim: true),
                        SizedBox(height: 20),
                      ],
                    );
                  }
                }),
                ConfirimButton(formkey: _formKey)
              ],
            )),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: (Text(message)));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class EmailFormFiled extends StatelessWidget {
  const EmailFormFiled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        onChanged: (value) =>
            context.read<LoginBloc>().add(LoginEmailChanged(email: value)),
        validator: (value) =>
            state.validateMail ? null : 'Такого почтового адреса не существует',
        decoration: const InputDecoration(
          labelText: 'Логин',
          hintText: 'Введите ваш логин',
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26, width: 2)),
        ),
      );
    });
  }
}

class PasswordFormFiled extends StatelessWidget {
  const PasswordFormFiled({Key? key, required this.isConfirim})
      : super(key: key);
  final bool isConfirim;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        onChanged: (value) => isConfirim
            ? context
                .read<LoginBloc>()
                .add(LoginPasswordConfirimChanged(password: value))
            : context
                .read<LoginBloc>()
                .add(LoginPasswordChanged(password: value)),
        validator: (value) => isConfirim
            ? (state.validateConfirimPassword ? null : 'Пароли не совпадают')
            : (state.validatePassword ? null : 'Минимальное кол-во знаков-7'),
        decoration: InputDecoration(
          labelText: isConfirim ? 'Подтвердите пароль' : 'Пароль',
          hintText:
              isConfirim ? 'Повторно введите пароль' : 'Введите ваш пароль',
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26, width: 2)),
        ),
      );
    });
  }
}

class ConfirimButton extends StatelessWidget {
  const ConfirimButton({Key? key, required this.formkey}) : super(key: key);

  final GlobalKey<FormState> formkey;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Column(
        children: [
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 6,
                  shadowColor: const Color(0x7841A0FF),
                  primary: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(state.isLogin ? 'Войти' : 'Зарегестрироваться'),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmit());
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.isLogin
                  ? 'У вас нет аккаунта?'
                  : 'У вас уже есть аккаунт?'),
              TextButton(
                  onPressed: () {
                    context
                        .read<LoginBloc>()
                        .add(LoginChangeType(loginType: !state.isLogin));
                  },
                  child: Text(state.isLogin ? 'Зарегестрироваться ' : 'Войти'))
            ],
          )
        ],
      );
    });
  }
}
