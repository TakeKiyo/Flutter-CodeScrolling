import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/pages/songs_list.dart';
import 'package:provider/provider.dart';

import 'login_form.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: _LoginCheck(),
    );
  }
}

class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    final bool _loggedIn = context.watch<AuthModel>().loggedIn;
    return _loggedIn ? SongsList() : LoginForm();
  }
}
