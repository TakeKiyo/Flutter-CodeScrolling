import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';

class ImportSong extends StatelessWidget {
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
  String copiedID = "";
  void _handleCopiedID(String inputText) {
    setState(() {
      copiedID = inputText;
    });
  }

  void importButtonClicked() {
    if (copiedID == "") {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("エラー"),
                content: Text("コピーした曲のIDを入力してください"),
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
                content: Text("曲のインポートを開始します"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("OK"),
                    onPressed: () async => importSong(),
                  ),
                ],
              ));
    }
  }

  void importSong() async {
    String udid = await FlutterUdid.udid;
    await FirebaseFirestore.instance
        .collection("Songs")
        .doc(copiedID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        var document = documentSnapshot.data() as Map;
        List<String> mermberIDList = document["memberID"].cast<String>();
        mermberIDList.add(udid);
        FirebaseFirestore.instance.collection("Songs").doc(copiedID).update({
          "memberID": mermberIDList,
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
  }

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: <Widget>[
          Text(
            "コピーしたIDを\nペーストしてください",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: TextStyle(color: Colors.black),
            maxLines: 1,
            onChanged: _handleCopiedID,
          ),
          ElevatedButton(
            child: const Text('曲をインポート', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(primary: Colors.orange),
            onPressed: () {
              importButtonClicked();
            },
          ),
        ],
      ),
    );
  }
}
