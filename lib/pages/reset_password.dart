import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String _email = "";

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  void setEmail(String s) {
    _email = s;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: (_, model, __) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'パスワード再設定',
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
                Text(
                  "パスワード再設定のメールを送信します",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                    fontSize: 15.0,
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
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: OutlinedButton(
                              child: Text("メールを送信",
                                  style: const TextStyle(fontSize: 25.0)),
                              style: OutlinedButton.styleFrom(
                                primary:
                                    Theme.of(context).textTheme.headline6.color,
                                side: const BorderSide(),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  // FocusScope.of(context).unfocus();
                                  print('aa');
                                }
                              }),
                        ),
                      ]),
                    )),
              ])));
    });
  }
}
