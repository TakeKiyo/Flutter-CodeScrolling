import 'package:flutter/material.dart';

import '../utils/firebase.dart';
import 'songs_list.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('main menu'),
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
                  checkFirebase();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return SongsList();
                    }),
                  );
                },
                child: Text('スタート')),
          ],
        ),
      ),
    );
  }
}
