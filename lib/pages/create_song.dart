import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';

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
          builder: (_) => CupertinoAlertDialog(
                title: Text("エラー"),
                content: Text("タイトルを入力してください"),
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
          builder: (_) => CupertinoAlertDialog(
                title: Text("確認"),
                content: Text(
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
      "codeList": [],
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
    });
    // 　ここはいずれ詳細ページにそのまま飛ばしたい
    Navigator.of(context).popUntil((route) => route.isFirst);
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
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
          ElevatedButton(
            child: const Text('曲を追加', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(primary: Colors.orange),
            onPressed: () {
              createButtonClicked();
            },
          ),
        ],
      ),
    );
  }
}
