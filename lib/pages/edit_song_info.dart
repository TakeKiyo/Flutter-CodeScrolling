import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';

class EditSongInfo extends StatefulWidget {
  final String artist;
  final String title;
  final int bpm;
  final String songKey;
  final String docId;
  EditSongInfo({
    Key key,
    this.title,
    this.artist,
    this.bpm,
    this.songKey,
    this.docId,
  }) : super(key: key);

  @override
  _EditSongInfoFormState createState() => _EditSongInfoFormState();
}

class _EditSongInfoFormState extends State<EditSongInfo> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  int _bpm;
  String _artist;
  String _key;
  int _selectedIndex;

  TextEditingController _titleEditingController;
  TextEditingController _artistEditingController;
  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController(text: widget.title);
    _artistEditingController = TextEditingController(text: widget.artist);
    _title = widget.title;
    _artist = widget.artist;
    _bpm = widget.bpm;
    _key = widget.songKey;
    _selectedIndex = _items.indexOf(widget.songKey);
  }

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

  void editSong() async {
    String udid = await FlutterUdid.udid;

    FirebaseFirestore.instance.collection("Songs").doc(widget.docId).update({
      "title": _title,
      "bpm": _bpm,
      "key": _key,
      "artist": _artist,
      "updatedAt": DateTime.now(),
      "udid": udid,
      "type": "edit",
    });
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('基本情報を編集'),
          actions: [
            TextButton(
              child: Text("完了",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  editSong();
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 5.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "曲名",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _titleEditingController,
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
                        controller: _artistEditingController,
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
                        child: const Text('キーを選択',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_key == "未選択") {
                            _onSelectedItemChanged(0);
                          }
                          _showModalPicker(context);
                        },
                      ),
                    ],
                  ),
                )))));
  }
}