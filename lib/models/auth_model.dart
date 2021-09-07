import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthModel() {
    final User _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _user = _currentUser;
      notifyListeners();
    }
  }

  User _user;
  User get user => _user;
  bool get loggedIn => _user != null;

  // 新規登録処理
  Future<String> signin(String email, String password) async {
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = _userCredential.user;
      notifyListeners();
      return "ok";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "email-already-in-use";
      } else {
        return "false";
      }
    } catch (e) {
      return "false";
    }
  }

  // ログイン処理
  Future<String> login(String email, String password) async {
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _user = _userCredential.user;
      notifyListeners();
      return "ok";
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        return "invalid-email";
      } else if (e.code == "user-not-found") {
        return "user-not-found";
      } else if (e.code == "wrong-password") {
        return "wrong-password";
      } else {
        return "false";
      }
    }
  }

  // ログアウト処理
  Future<void> logout() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _user = null;
    await _auth.signOut();
    notifyListeners();
  }
}
