import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:provider/provider.dart';

class ImportSongById extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('曲をインポート'),
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
              title: const Text("確認"),
              content: const Text("曲のインポートを開始します"),
              actions: <Widget>[
                TextButton(
                  child: const Text("キャンセル"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () async => importSong(copiedID),
                ),
              ],
            ));
  }

  void importSong(String docId) async {
    String uid = Provider.of<AuthModel>(context, listen: false).user.uid;
    try {
      await FirebaseFirestore.instance
          .collection("Songs")
          .doc(docId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var document = documentSnapshot.data() as Map;
          List<String> memberIDList = document["memberID"].cast<String>();
          memberIDList.add(uid);
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
              backgroundColor: Theme.of(context).colorScheme.error,
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
      // print(e);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
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
                    const Text(
                      "コピーしたIDをペーストしても \n 追加することができます",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    TextFormField(
                      onChanged: _handleCopiedID,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'IDを入力してください。';
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: OutlinedButton(
                        child: const Text('曲をインポート'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            importButtonClicked();
                          }
                        },
                      ),
                    ),
                  ]))),
        ]));
  }
}
