import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import 'create_song.dart';
import 'detail_page/detail_page.dart';

class SongsList extends StatelessWidget {
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
        body: Container(
          child: Scrollbar(
            isAlwaysShown: true,
            thickness: 8.0,
            hoverThickness: 12.0,
            child: SingleChildScrollView(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Songs')
                    .where("userID",
                        isEqualTo: Provider.of<AuthModel>(context).udid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Text('Loading...'),
                        ]));
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Text('保存された曲はありません'),
                        ]));
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
                                child: Text(doc["title"])))
                            .toList());
                  }
                },
              ),
            )),
          ),
        ));
  }
}
