import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/auth_bloc/auth_repository.dart';
import 'package:todo_app/app/auth_bloc/landing_bloc/landing_bloc.dart';
import 'package:todo_app/app/auth_bloc/landing_bloc/landing_event.dart';
import 'package:todo_app/app/auth_bloc/landing_bloc/landing_status.dart';
import 'package:todo_app/app/auth_bloc/login_bloc/login_view.dart';
import 'package:todo_app/app/home_bloc/home_view.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          LandingBloc(authRepository: context.read<AuthRepository>()),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: LandingView(),
      ),
    );
  }
}

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    context.read<LandingBloc>().add(LandingLoadTokenEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LandingBloc, LandingState>(
      listener: (context, state) {
        final status = state.landingStatus;
        if (status is LandingAuthed) {
          Future.delayed(
              const Duration(seconds: 1),
              () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(user: status.user.user!.uid)),
                  (route) => false));
        } else if (status is LandingDontHaveToken) {
          Future.delayed(
              const Duration(seconds: 1),
              () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false));
        } else if (status is LandingError) {
          Future.delayed(
              const Duration(seconds: 1),
              () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(),
          SizedBox(
            width: double.infinity,
            height: 90,
            child: Image.asset('assets/logo.png'),
          ),
          const SizedBox(height: 30),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                    text: 'TODO ', style: TextStyle(color: Colors.blueAccent)),
                TextSpan(text: 'APP')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
