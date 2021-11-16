import 'package:firebase_auth/firebase_auth.dart';

abstract class LandingStatus {
  const LandingStatus();
}

class LandingInitialStatus extends LandingStatus {
  const LandingInitialStatus();
}

class LandingLoading extends LandingStatus {}

class LandingDontHaveToken extends LandingStatus {}

class LandingAuthed extends LandingStatus {
  UserCredential user;
  LandingAuthed({required this.user});
}

class LandingError extends LandingStatus {
  Exception error;
  LandingError({required this.error});
}
