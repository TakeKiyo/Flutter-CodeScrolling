import 'package:cloud_firestore/cloud_firestore.dart';
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

  void submitSong() async {
    String udid = await FlutterUdid.udid;

    FirebaseFirestore.instance.collection("Songs").add({
      "title": _title,
      "bpm": _bpm,
      "userID": udid,
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return SongsList();
      }),
    );

    // print()
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
            // "タイトルを入力",
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
              submitSong();
            },
          ),
        ],
      ),
    );
  }
}
