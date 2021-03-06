import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/pages/signin_form.dart';
import 'package:my_app/pages/songs_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _loggedIn = context.watch<AuthModel>().loggedIn;
    return _loggedIn ? SongsList() : SigninForm();
  }
}
