import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';

import 'songs_list.dart';

class CreateSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('曲追加ページ'),
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
      body: Center(child: CreateSongForm()),
    );
  }
}

class CreateSongForm extends StatefulWidget {
  @override
  _CreateSongFormState createState() => _CreateSongFormState();
}

class _CreateSongFormState extends State<CreateSongForm> {
  String _title = "";
  int _bpm = 120;
  void _handleTitle(String inputText) {
    setState(() {
      _title = inputText;
    });
  }

  void _handleBpm(String inputText) {
    setState(() {
      _bpm = int.parse(inputText);
    });
  }

  void createButtonClicked() {
    // TODO バリデーションが満たされてなかったwarning いけてたら確認ダイアログ
    if (_title == "") {
      showDialog(
          context: context,
          builder: (_) => new CupertinoAlertDialog(
                title: new Text("エラー"),
                content: new Text("タイトルを入力してください"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => new CupertinoAlertDialog(
                title: new Text("確認"),
                content: new Text(
                    "以下の曲を作成します\nタイトル: ${_title.toString()}\nBPM: ${_bpm.toString()}"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("OK"),
                    onPressed: () async => createSong(),
                  ),
                ],
              ));
    }
  }

  void createSong() async {
    String udid = await FlutterUdid.udid;

    FirebaseFirestore.instance.collection("Songs").add({
      "title": _title,
      "bpm": _bpm,
      "userID": udid,
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
    });
    // 　ここはいずれ詳細ページにそのまま飛ばしたい
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return SongsList();
      }),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: <Widget>[
          Text(
            "タイトル $_title",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            maxLengthEnforced: true,
            style: TextStyle(color: Colors.black),
            maxLines: 1,
            onChanged: _handleTitle,
          ),
          Text(
            "bpm $_bpm",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(color: Colors.black),
            maxLines: 1,
            onChanged: _handleBpm,
          ),
          RaisedButton(
            child: const Text('曲を追加'),
            color: Colors.orange,
            textColor: Colors.white,
            onPressed: () {
              createButtonClicked();
            },
          ),
        ],
      ),
    );
  }
}
