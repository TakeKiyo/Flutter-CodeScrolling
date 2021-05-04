import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class CounterModel extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
    checkFirebase();
  }

  void checkFirebase() {
    print('firebase test');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference testRef = firestore.collection('test');
    var doc = testRef.doc('Cw0TbgK0w0FtA3vt2XRo');
    doc.get().then((value) => print(value.data()));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider<CounterModel>(
        create: (_) => CounterModel(),
        child: Scaffold(
          appBar: AppBar(title: Text('Flutter Demo Home Page')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                CounterText(),
              ],
            ),
          ),
          floatingActionButton: Consumer<CounterModel>(builder: (_, model, __) {
            return FloatingActionButton(
              onPressed: model.increment,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            );
          }), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      Provider.of<CounterModel>(context).count.toString(),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
