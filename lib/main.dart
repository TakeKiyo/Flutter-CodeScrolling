import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/detail_page.dart';
import 'package:my_app/ScrollModel.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

void checkFirebase() {
  print('firebase test');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference testRef = firestore.collection('test');
  var doc = testRef.doc('Cw0TbgK0w0FtA3vt2XRo');
  doc.get().then((value) => print(value.data()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollModel>(
        create: (_) => ScrollModel(),
    child: MaterialApp(
      title: 'Code Scrolling',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MyHomePage(),
    ));
  }
}

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
                  checkFirebase();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return DetailPage();
                    }),
                  );
                },
                child: Text('次のページへ')),
          ],
        ),
      ),
    );
  }
}
