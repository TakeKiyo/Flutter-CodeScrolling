import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:provider/provider.dart';

import '../models/metronome_model.dart';
import 'create_song.dart';
import 'detail_page.dart';

class SongsList extends StatelessWidget {
  Future<String> getUdid() async {
    String udid = await FlutterUdid.udid;
    return Future.value(udid.toString());
  }

  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder(
                future: getUdid(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> udidData) {
                  if (udidData.hasData) {
                    print('udid: ' + udidData.data);
                    // ここのprintで自分のiPhoneのデバイスIDちぇっくしてください
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Songs')
                                .where("userID", isEqualTo: udidData.data)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.docs.length == 0) {
                                  return Text('保存された曲はありません');
                                } else {
                                  final List<DocumentSnapshot> documents =
                                      snapshot.data.docs;
                                  return ListView(
                                      children: documents
                                          .map((doc) => TextButton(
                                              onPressed: () {
                                                print(doc["bpm"]);
                                                Provider.of<MetronomeModel>(
                                                        context,
                                                        listen: false)
                                                    .tempoCount = doc["bpm"];
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return DetailPage(
                                                        bpm: doc["bpm"],
                                                        title: doc["Title"],
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text(doc["Title"])))
                                          .toList());
                                }
                              } else {
                                return Text('エラーが発生しました');
                              }
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return Text("loading");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
