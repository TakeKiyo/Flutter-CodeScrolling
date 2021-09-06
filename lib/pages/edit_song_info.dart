import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:provider/provider.dart';

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

  void editSong() {
    String uid = Provider.of<AuthModel>(context, listen: false).user.uid;

    FirebaseFirestore.instance.collection("Songs").doc(widget.docId).update({
      "title": _title,
      "bpm": _bpm,
      "key": _key,
      "artist": _artist,
      "updatedAt": DateTime.now(),
      "uid": uid,
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
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyText1.color,
        fontSize: 32,
      ),
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
          title: const Text('基本情報を編集'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                child: const Text("完了", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    editSong();
                  }
                },
              ),
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
                      const EdgeInsets.only(left: 30, right: 30, top: 15.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _titleEditingController,
                        style: const TextStyle(fontSize: 25.0),
                        decoration: const InputDecoration(
                          icon: const Padding(
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
                        controller: _artistEditingController,
                        style: const TextStyle(fontSize: 25.0),
                        decoration: const InputDecoration(
                          icon: const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Icon(Icons.person, size: 30.0)),
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
                                const Text(
                                  "キー  ",
                                  style: TextStyle(fontSize: 25.0),
                                ),
                                OutlinedButton(
                                  child: Text(_key,
                                      style: const TextStyle(fontSize: 25.0)),
                                  style: OutlinedButton.styleFrom(
                                    primary: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .color,
                                    side: const BorderSide(),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _showModalPicker(context);
                                  },
                                ),
                              ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Text(
                            "BPM: $_bpm",
                            style: const TextStyle(fontSize: 25.0),
                          )),
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
