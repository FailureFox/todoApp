import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/auth_bloc/auth_repository.dart';
import 'package:todo_app/app/auth_bloc/landing_bloc/landing_event.dart';
import 'package:todo_app/app/auth_bloc/landing_bloc/landing_status.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  AuthRepository authRepository;

  LandingBloc({required this.authRepository}) : super(LandingState());

  @override
  Stream<LandingState> mapEventToState(LandingEvent event) async* {
    if (event is LandingLoadTokenEvent) {
      try {
        String? token = await authRepository.loadToken();
        if (token == null) {
          yield state.copyWith(landingStatus: LandingDontHaveToken());
        } else {
          yield state.copyWith(landingStatus: LandingLoading());
          UserCredential user = await authRepository.signInWithToken();
          yield state.copyWith(landingStatus: LandingAuthed(user: user));
        }
      } catch (e) {
        print(e);
        yield state.copyWith(landingStatus: LandingError(error: Exception(e)));
      }
    }
  }
}

class LandingState {
  bool isHaveToken;
  LandingStatus landingStatus;

  LandingState(
      {this.isHaveToken = false,
      this.landingStatus = const LandingInitialStatus()});
  LandingState copyWith({bool? isHaveToken, LandingStatus? landingStatus}) {
    return LandingState(
        isHaveToken: isHaveToken ?? this.isHaveToken,
        landingStatus: landingStatus ?? this.landingStatus);
  }
}
