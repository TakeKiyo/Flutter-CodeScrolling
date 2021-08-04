import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:provider/provider.dart';

import '../models/metronome_model.dart';
import 'create_song.dart';
import 'detail_page/detail_page.dart';

class SongsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void deleteButtonClicked(String docId) {
      FirebaseFirestore.instance.collection('Songs').doc(docId).delete();
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('曲一覧'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                //addボタンを押したら反応
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CreateSong();
                  }),
                );
              }),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                //shareボタンを押したら反応
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('曲を選択してください'),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Songs')
                    .where("userID",
                        isEqualTo: Provider.of<AuthModel>(context).udid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  if (snapshot.data.docs.length == 0) {
                    return Text('保存された曲はありません');
                  } else {
                    final List<DocumentSnapshot> documents = snapshot.data.docs;
                    return ListView(
                        children: documents
                            .map((doc) => TextButton(
                                onPressed: () {
                                  print(doc["bpm"]);
                                  Provider.of<MetronomeModel>(context,
                                          listen: false)
                                      .tempoCount = doc["bpm"];
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DetailPage(
                                          bpm: doc["bpm"],
                                          title: doc["title"],
                                          docId: doc.id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32.0),
                                        child: Text(
                                          doc["title"],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CupertinoAlertDialog(
                                                    title: Text("確認"),
                                                    content: Text(
                                                        "${doc["title"]}を削除してもよいですか？"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text("キャンセル"),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                      TextButton(
                                                        child: Text("OK"),
                                                        onPressed: () =>
                                                            deleteButtonClicked(
                                                                doc.id),
                                                      ),
                                                    ],
                                                  ));
                                        }),
                                  ],
                                )))
                            .toList());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
