import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  String _udid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthModel() {
    final User _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _user = _currentUser;
      notifyListeners();
    }
  }
  String get udid => _udid;

  User _user;
  User get user => _user;
  bool get loggedIn => _user != null;

  // 新規登録処理
  Future<bool> signin(String email, String password) async {
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = _userCredential.user;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ログイン処理
  Future<bool> login(String email, String password) async {
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _user = _userCredential.user;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
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
