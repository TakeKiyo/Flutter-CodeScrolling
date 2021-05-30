import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import '../models/metronome_model.dart';
import 'package:provider/provider.dart';

class SongsList extends StatelessWidget {
  // String _udid;

  // SongsList() {
  //   Future<String> futureUdid = getUdid();
  //   futureUdid.then((value) => {print(value)});
  //   print(_udid);
  // }

  // Future<String> getUdid() async {
  //   String udid = await FlutterUdid.udid;
  //   return udid;
  // }

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
                    // .where("userID", isEqualTo: _udid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
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
                                    MaterialPageRoute(builder: (context) {
                                      return DetailPage(
                                        bpm: doc["bpm"],
                                        title: doc["Title"],
                                      );
                                    }),
                                  );
                                },
                                child: Text(doc["Title"])))
                            .toList());
                  } else if (snapshot.hasError) {
                    return Text('エラーが発生しました');
                  } else {
                    return Text('保存された曲はありません');
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
