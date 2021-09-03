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
import 'setting_page.dart';

class SongsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('曲一覧'),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: Icon(Icons.toc),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => SettingPage()));
              },
            ),
          ),
          actions: [],
        ),
        body: SongsListForm(),
        floatingActionButton: Container(
            width: 70.0,
            height: 70.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return CreateSong();
                      }),
                );
              },
              child: const Icon(
                Icons.add,
                size: 40.0,
              ),
            )));
  }
}

class SongsListForm extends StatefulWidget {
  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsListForm> {
  List<Widget> songsList = [];
  String searchText = "";
  TextEditingController _textEditingController;
  final SlidableController slidableController = SlidableController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
  }

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
            "type": "removeMember",
            "memberID": memberIDList,
            "updatedAt": DateTime.now(),
          });
        }
      });
      Navigator.pop(context);
    }

    void createSong() async {
      String udid = await FlutterUdid.udid;

      List<String> codeList = [
        "A,A,A,A",
        "A,A,A,A",
        "A,E,Fm,B",
        "A,E,Fm,B",
        "D,C,F,G",
        "A,E,C,E",
        "A,A,A,A",
      ];

      List<String> lyricsList = [
        "",
        "",
        "Aメロの歌詞1",
        "Aメロの歌詞2",
        "Bメロの歌詞",
        "サビの歌詞",
        "英語や長い文章でも適切に表示することができます。",
      ];

      List<String> rhythmList = [
        "4/4",
        "4/4",
        "4/4",
        "4/4",
        "4/4",
        "4/4",
        "4/4",
      ];

      List<String> separation = [
        "Intro",
        "Intro",
        "A",
        "A",
        "B",
        "サビ",
        "サビ",
      ];
      FirebaseFirestore.instance.collection("Songs").add({
        "title": "サンプル曲",
        "bpm": 120,
        "key": "C / Am",
        "artist": "サンプルアーティスト",
        "userID": udid,
        "memberID": [udid],
        "codeList": codeList,
        "lyricsList": lyricsList,
        "rhythmList": rhythmList,
        "separation": separation,
        "createdAt": DateTime.now(),
        "updatedAt": DateTime.now(),
      });
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
                TextButton(
                    onPressed: () {
                      createSong();
                    },
                    child: Text("サンプル曲を作成してみる"))
              ]));
        } else {
          final List<DocumentSnapshot> documents = snapshot.data.docs;
          songsList = [];
          documents.forEach((doc) {
            if (searchText == "" ||
                doc["title"].toString().contains(searchText)) {
              songsList.add(Slidable(
                  controller: slidableController,
                  actionExtentRatio: 0.2,
                  actionPane: SlidableScrollActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      caption: '削除',
                      color: Colors.red,
                      icon: Icons.delete,
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

          return Scrollbar(
              thickness: 8.0,
              hoverThickness: 12.0,
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                        child: TextField(
                          controller: _textEditingController,
                          onChanged: (text) {
                            setState(() {
                              searchText = text;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "曲名を検索する",
                            suffixIcon: IconButton(
                              onPressed: () {
                                _textEditingController.clear();
                                setState(() {
                                  searchText = "";
                                });
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        )),
                    ListView(
                      padding: EdgeInsets.all(12.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: songsList,
                    )
                  ])));
        }
      },
    );
  }
}
