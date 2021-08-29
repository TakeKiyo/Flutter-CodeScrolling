import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';

class ImportSongById extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('曲をインポート'),
        actions: [],
      ),
      body: Center(child: ImportSongForm()),
    );
  }
}

class ImportSongForm extends StatefulWidget {
  @override
  _ImportSongFormState createState() => _ImportSongFormState();
}

class _ImportSongFormState extends State<ImportSongForm> {
  final _formKey = GlobalKey<FormState>();
  String copiedID = "";
  void _handleCopiedID(String inputText) {
    setState(() {
      copiedID = inputText;
    });
  }

  void importButtonClicked() {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("確認"),
              content: Text("曲のインポートを開始します"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () async => importSong(copiedID),
                ),
              ],
            ));
  }

  void importSong(String docId) async {
    String udid = await FlutterUdid.udid;
    try {
      await FirebaseFirestore.instance
          .collection("Songs")
          .doc(docId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var document = documentSnapshot.data() as Map;
          List<String> memberIDList = document["memberID"].cast<String>();
          memberIDList.add(udid);
          memberIDList = memberIDList.toSet().toList();
          FirebaseFirestore.instance.collection("Songs").doc(docId).update({
            "type": "addMember",
            "memberID": memberIDList,
            "updatedAt": DateTime.now(),
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: const Text('曲が存在していません'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      });
    } catch (e) {
      print(e);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text('エラーが発生しました'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50),
        child: Column(children: <Widget>[
          Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(children: <Widget>[
                    Text(
                      "コピーしたIDをペーストしても",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "追加することができます",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      onChanged: _handleCopiedID,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'IDを入力してください。';
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('曲をインポート',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          importButtonClicked();
                        }
                      },
                    ),
                  ]))),
        ]));
  }
}
