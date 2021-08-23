import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';

import 'import_song_page.dart';

class CreateSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('曲追加ページ'),
        actions: [],
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
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  int _bpm = 120;
  String _artist = "";
  String _key = "未選択";
  int _selectedIndex = 0;

  void _handleTitle(String inputText) {
    setState(() {
      _title = inputText;
    });
  }

  void _handleBpm(double inputText) {
    setState(() {
      _bpm = inputText.toInt();
    });
  }

  void _handleArtist(String inputText) {
    setState(() {
      _artist = inputText;
    });
  }

  void createButtonClicked() {
    if (_key == "未選択") {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("エラー"),
                content: Text("キーを選択してください。"),
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
                    "以下の曲を作成します\n 曲名: ${_title.toString()}\n アーティスト: ${_artist.toString()}\n BPM: ${_bpm.toString()}\n キー: ${_key.toString()}"),
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
      "key": _key,
      "artist": _artist,
      "userID": udid,
      "memberID": [udid],
      "codeList": [],
      "lyricsList": [],
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
    });
    // 　ここはいずれ詳細ページにそのまま飛ばしたい
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showModalPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _items.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChanged,
              scrollController:
                  FixedExtentScrollController(initialItem: _selectedIndex),
            ),
          ),
        );
      },
    );
  }

  Widget _pickerItem(String str) {
    return Text(
      str,
      style: const TextStyle(fontSize: 32),
    );
  }

  void _onSelectedItemChanged(int index) {
    setState(() {
      _key = _items[index];
      _selectedIndex = index;
    });
  }

  final List<String> _items = [
    'C / Am',
    'C# / A#m',
    'D / Bm',
    'E♭ / Cm',
    'E / C#m',
    'F / Dm',
    'F# / D#m',
    'G / Em',
    'A♭ / Fm',
    'A / F#m',
    'B♭ / Gm',
    'B / G#m',
  ];

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ImportSong();
                          }),
                        );
                      },
                      child: Text('友だちの曲の追加はこちら'))),
              Text(
                "曲名",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                cursorColor: Colors.black,
                onChanged: _handleTitle,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return '曲名を入力してください。';
                  }
                },
              ),
              Text(
                "アーティスト",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                cursorColor: Colors.black,
                onChanged: _handleArtist,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'アーティストを入力してください。';
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Text(
                    "BPM: $_bpm",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Text(
                "いつでも変更可能です",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                activeColor: Colors.black,
                inactiveColor: Theme.of(context).primaryColorDark,
                label: null,
                value: _bpm.toDouble(),
                divisions: 270,
                min: 30,
                max: 300,
                onChanged: _handleBpm,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "キー $_key",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              ElevatedButton(
                child:
                    const Text('キーを選択', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                onPressed: () {
                  _showModalPicker(context);
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: ElevatedButton(
                    child: const Text('曲を追加',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        createButtonClicked();
                      }
                    },
                  )),
            ],
          ),
        )));
  }
}
