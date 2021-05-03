import 'package:flutter/material.dart';
import 'package:my_app/detail_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Scrolling',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text('main menu'),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    //addボタンを押したら反応
                  }
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: (){
                    //shareボタンを押したら反応
                  }
                ),
              ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(onPressed: () {
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
