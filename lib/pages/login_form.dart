import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/pages/songs_list.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'ログイン',
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
            actions: [],
          ),
          extendBodyBehindAppBar: true,
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
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 10.0),
                      child: Column(children: <Widget>[
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                          decoration: const InputDecoration(
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
                            if (value.isEmpty) {
                              return 'パスワードを入力してください';
                            }
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: OutlinedButton(
                              child: Text("ログイン",
                                  style: const TextStyle(fontSize: 25.0)),
                              style: OutlinedButton.styleFrom(
                                primary:
                                    Theme.of(context).textTheme.headline6.color,
                                side: const BorderSide(),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  // FocusScope.of(context).unfocus();
                                  try {
                                    if (await model.login(_email, _password)) {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return SongsList();
                                        }),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
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
                              }),
                        ),
                      ]),
                    )),
              ])));
    });
  }
}
