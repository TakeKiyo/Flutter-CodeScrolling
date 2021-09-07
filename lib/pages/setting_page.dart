import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<DropdownMenuItem<int>> _themeList = const [
    DropdownMenuItem(
      value: 0,
      child: const Text("自動"),
    ),
    DropdownMenuItem(
      value: 1,
      child: const Text("明るい"),
    ),
    DropdownMenuItem(
      value: 2,
      child: const Text("ダーク"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Future<void> _launchInWebViewOrVC(String url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: true,
          forceWebView: true,
          headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(flex: 1, child: const Text("アプリテーマ：　")),
                        Flexible(
                          flex: 1,
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child:
                                Consumer<ThemeModel>(builder: (_, theme, __) {
                              return DropdownButton<int>(
                                isExpanded: true,
                                value: theme.themeIndex,
                                elevation: 16,
                                onChanged: (int newValue) {
                                  theme.themeIndex = newValue;
                                },
                                items: _themeList,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          leading: Icon(Icons.lock),
                          title: Text("プライバシーポリシーを見る"),
                          onTap: () {
                            String privacyPolicyURL =
                                "https://band-out.studio.site/privacyPolicy";
                            _launchInWebViewOrVC(privacyPolicyURL);
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          leading: Icon(Icons.question_answer),
                          title: Text("お問い合わせ"),
                          onTap: () {
                            String contactURL =
                                "https://band-out.studio.site/contact";
                            _launchInWebViewOrVC(contactURL);
                          },
                        )),
                    (Provider.of<AuthModel>(context, listen: false).loggedIn)
                        ? OutlinedButton(
                            child: const Text('ログアウトする'),
                            style: OutlinedButton.styleFrom(
                              primary:
                                  Theme.of(context).textTheme.headline6.color,
                              side: const BorderSide(),
                            ),
                            onPressed: () async {
                              Provider.of<AuthModel>(context, listen: false)
                                  .logout();
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                          )
                        : Container(
                            child: null,
                          )
                  ],
                ),
              ]))),
    );
  }
}
