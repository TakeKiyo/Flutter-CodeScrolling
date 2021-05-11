import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/pages/detail_page.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email;
  String _password;

  void setEmail(String s) {
    _email = s;
  }

  void setPassword(String s) {
    _password = s;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setEmail(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setPassword(value);
                },
              ),
              TextButton(
                  onPressed: () async {
                    print('ボタンが押された');
                    print(_email);
                    print(_password);
                    try {
                      if (await model.login(_email, _password)) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return DetailPage();
                          }),
                        );
                      } else {
                        print('ログイン失敗');
                      }
                    } catch (e) {
                      print('error');
                    }
                  },
                  child: Text('ログイン')),
            ],
          ),
        ),
      );
    });
  }
}
