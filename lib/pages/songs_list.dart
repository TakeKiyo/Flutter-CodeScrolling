import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import 'create_song.dart';
import 'detail_page/tab_view.dart';

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
          ],
        ),
        body: SongsListForm());
  }
}

class SongsListForm extends StatefulWidget {
  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsListForm> {
  String searchText = "";
  List<Widget> songsList = [];
  @override
  Widget build(BuildContext context) {
    void deleteButtonClicked(String docId) async {
      String udid = await FlutterUdid.udid;
      await FirebaseFirestore.instance
          .collection("Songs")
          .doc(docId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        var document = documentSnapshot.data() as Map;
        List<String> memberIDList = document["memberID"].cast<String>();
        if (memberIDList.length == 1) {
          FirebaseFirestore.instance.collection('Songs').doc(docId).delete();
        } else {
          memberIDList.remove(udid);
          FirebaseFirestore.instance.collection("Songs").doc(docId).update({
            "memberID": memberIDList,
            "updatedAt": DateTime.now(),
          });
        }
      });
      Navigator.pop(context);
    }

    final _scrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Songs')
          .where("memberID",
              arrayContains: Provider.of<AuthModel>(context).udid)
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
          songsList = [];
          documents.forEach((doc) {
            if (searchText == "" ||
                doc["title"].toString().contains(searchText)) {
              songsList.add(Slidable(
                  actionExtentRatio: 0.2,
                  actionPane: SlidableScrollActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      caption: '削除',
                      color: Colors.red,
                      icon: Icons.remove,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  title: Text("確認"),
                                  content: Text("${doc["title"]}を削除してもよいですか？"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("キャンセル"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () =>
                                          deleteButtonClicked(doc.id),
                                    ),
                                  ],
                                ));
                      },
                    ),
                  ],
                  child: TextButton(
                    onPressed: () {
                      print(doc["bpm"]);
                      Provider.of<MetronomeModel>(context, listen: false)
                          .tempoCount = doc["bpm"];
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            var tempMap = doc.data() as Map;
                            String artist = "";
                            String songKey = "";
                            if (tempMap.containsKey("artist")) {
                              artist = tempMap["artist"];
                            }
                            if (tempMap.containsKey("key")) {
                              songKey = tempMap["key"];
                            }
                            return TabView(
                              bpm: doc["bpm"],
                              title: doc["title"],
                              artist: artist,
                              songKey: songKey,
                              docId: doc.id,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      child: ListTile(
                        title: Center(child: Text(doc["title"])),
                      ),
                    ),
                  )));
            }
          });

          return Column(children: <Widget>[
            TextField(
              onChanged: (text) {
                searchText = text;
                setState(() {
                  searchText = text;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Container(
                child: Scrollbar(
                    isAlwaysShown: true,
                    thickness: 8.0,
                    hoverThickness: 12.0,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        child: ListView(
                            padding: EdgeInsets.all(12.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: songsList))))
          ]);
        }
      },
    );
    // );
    //   ),
    // ));
  }
}
