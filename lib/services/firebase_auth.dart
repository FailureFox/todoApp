import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthService {
  final FirebaseAuth _fauth = FirebaseAuth.instance;
  Future<UserCredential> loginWithEmailPassoword(
      {required String email, required String password}) async {
    try {
      final UserCredential user = await _fauth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      throw e is FirebaseAuthException ? Exception(e.message) : Exception(e);
    }
  }

Future<UserCredential>  registerWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential user = await _fauth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      throw e is FirebaseAuthException ? Exception(e.message) : Exception(e);
    }
  }
}
