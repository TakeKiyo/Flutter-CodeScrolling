import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/pages/login_form.dart';
import 'package:my_app/pages/songs_list.dart';
import 'package:provider/provider.dart';

class SigninForm extends StatefulWidget {
  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  String _email = "";
  String _password = "";
  bool _showPassword = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

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
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
            Text(
              'Bandout',
              style: TextStyle(
                fontFamily: 'Rochester',
                fontSize: 50,
              ),
            ),
            Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 10.0),
                  child: Column(children: <Widget>[
                    TextFormField(
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'メールアドレス',
                      ),
                      onChanged: (String value) {
                        setEmail(value);
                      },
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'メールアドレスを入力してください。';
                        }
                      },
                    ),
                    TextFormField(
                      obscureText: !_showPassword,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye),
                        ),
                      ),
                      onChanged: (String value) {
                        setPassword(value);
                      },
                      // ignore: missing_return
                      validator: (value) {
                        if (value.length < 8) {
                          return '8文字以上のパスワードを設定してください。';
                        }
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            child: Text("登録",
                                style: const TextStyle(fontSize: 25.0)),
                            style: OutlinedButton.styleFrom(
                              primary:
                                  Theme.of(context).textTheme.headline6.color,
                              side: const BorderSide(),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  if (await model.signin(_email, _password)) {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return SongsList();
                                      }),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Theme.of(context).colorScheme.error,
                                        content: const Text(
                                            'エラーが発生しました。\n もう一度お試しください。'),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      content: const Text(
                                          'エラーが発生しました。\n もう一度お試しください。'),
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        )),
                    Text(
                      "アカウントをお持ちですか？",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 15.0,
                      ),
                    ),
                    OutlinedButton(
                      child:
                          Text("ログイン", style: const TextStyle(fontSize: 20.0)),
                      style: OutlinedButton.styleFrom(
                        primary: Theme.of(context).textTheme.headline6.color,
                        side: const BorderSide(),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return LoginForm();
                        }));
                      },
                    ),
                  ]),
                )),
          ])));
    });
  }
}
