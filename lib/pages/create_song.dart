import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';

import 'import_song_by_id.dart';
import 'import_song_page.dart';

class CreateSong extends StatefulWidget {
  @override
  _CreateSongFormState createState() => _CreateSongFormState();
}

class _CreateSongFormState extends State<CreateSong> {
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
              backgroundColor: Theme.of(context).primaryColorLight,
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('曲追加ページ'),
          actions: [
            TextButton(
              child: Text("作成", style: TextStyle(fontSize: 18)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  createButtonClicked();
                }
              },
            ),
          ],
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Container(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, top: 10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: OutlinedButton(
                                    onPressed: () => {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return ImportSongById();
                                        }),
                                      ),
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.only(
                                          top: 12.0, bottom: 12.0),
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: null,
                                          ),
                                          Text('IDから\n追加する',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryTextTheme
                                                      .caption
                                                      .color)),
                                        ]),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: OutlinedButton(
                                    onPressed: () => {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return ImportSong();
                                        }),
                                      ),
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.only(
                                          top: 12.0, bottom: 12.0),
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.qr_code),
                                          onPressed: null,
                                        ),
                                        Text(
                                          'QRコードから\n追加する',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryTextTheme
                                                  .caption
                                                  .color),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ])),
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 25.0,
                        ),
                        decoration: const InputDecoration(
                          icon: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Icon(Icons.music_note, size: 30.0)),
                          labelText: '曲名',
                        ),
                        onChanged: _handleTitle,
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return '曲名を入力してください。';
                          }
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 25.0,
                        ),
                        decoration: const InputDecoration(
                          icon: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: const Icon(Icons.person, size: 30.0)),
                          labelText: 'アーティスト',
                        ),
                        onChanged: _handleArtist,
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'アーティストを入力してください。';
                          }
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "キー  ",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1
                                        .color,
                                    fontSize: 25.0,
                                  ),
                                ),
                                OutlinedButton(
                                  child: Text((_key == "未選択") ? "キーを選択" : _key,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1
                                            .color,
                                        fontSize: 25.0,
                                      )),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_key == "未選択") {
                                      _onSelectedItemChanged(0);
                                    }
                                    _showModalPicker(context);
                                  },
                                ),
                              ])),
                      Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: Text(
                            "BPM: $_bpm",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          )),
                      Text(
                        "いつでも変更可能です",
                        style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.caption.color,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        label: null,
                        value: _bpm.toDouble(),
                        divisions: 270,
                        min: 30,
                        max: 300,
                        onChanged: _handleBpm,
                      ),
                    ],
                  ),
                )))));
  }
}
