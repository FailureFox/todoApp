import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/services/firebase_auth.dart';

class AuthRepository {
  final FireBaseAuthService _auth = FireBaseAuthService();
  String userId = '';
  final _storage = const FlutterSecureStorage();

  Future<UserCredential> loginWithEMalAndPassword(
      String mail, String password) async {
    final user = await _auth.loginWithEmailPassoword(
        email: mail.toLowerCase(), password: password.toLowerCase());
    //Сделал так потому-что в firebase нет входа по токену, есть только по customToken
    _storage.write(key: 'token', value: mail);
    _storage.write(key: 'pass', value: password);
    return user;
  }

  Future<UserCredential> regitrationWithEmailAndPassword(mail, password) async {
    final user =
        await _auth.registerWithEmailPassword(email: mail, password: password);
    //Сделал так потому-что в firebase нет входа по токену, есть только по customToken
    _storage.write(key: 'token', value: mail);
    _storage.write(key: 'pass', value: password);
    return user;
  }

  Future<UserCredential> signInWithToken() async {
    //Сделал так потому-что в firebase нет входа по токену, есть только по customToken который нужно создать через node js итд
    final String _token = await loadToken() as String;
    final String _pass = await _storage.read(key: 'pass') as String;
    UserCredential user =
        await _auth.loginWithEmailPassoword(email: _token, password: _pass);
    return user;
  }

  void saveToken(String token) async =>
      await _storage.write(key: 'token', value: token);

  Future<bool> isHaveToken() async => await loadToken() != null;

  Future<String?> loadToken() async {
    String? token = await _storage.read(key: 'token');
    return token;
  }
}
// 'Fm3T8KH644MrGlUNIGqEwZWZRfg1'
