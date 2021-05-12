import 'package:flutter/material.dart';
import 'package:my_app/pages/detail_page.dart';
import 'package:my_app/pages/login_form.dart';

import '../utils/firebase.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('main menu'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                //addボタンを押したら反応
              }),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                //shareボタンを押したら反応
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return LoginForm();
                    }),
                  );
                },
                child: Text('ログインする')),
            TextButton(
                onPressed: () {
                  checkFirebase();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DetailPage();
                    }),
                  );
                },
                child: Text('ログインなしで使う')),
          ],
        ),
      ),
    );
  }
}
