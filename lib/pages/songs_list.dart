import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:my_app/services/anchored_adaptive_banner.dart';
import 'package:provider/provider.dart';

import 'create_song.dart';
import 'detail_page/tab_view.dart';
import 'login_form.dart';
import 'setting_page.dart';

class SongsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Bandout',
            style: TextStyle(
              fontFamily: 'Rochester',
              fontSize: 35,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.toc),
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
        floatingActionButton: context.watch<AuthModel>().loggedIn
            ? Container(
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
                ))
            : Container(child: null));
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
      String uid = Provider.of<AuthModel>(context, listen: false).user.uid;

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
          memberIDList.remove(uid);
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
      String uid = Provider.of<AuthModel>(context, listen: false).user.uid;

      List<String> codeList = const [
        "A,A,A,A",
        "A,A,A,A",
        "A,E,Fm,B",
        "A,E,Fm,B",
        "D,C,F,G",
        "A,E,C,E",
        "A,A,A,A",
      ];

      List<String> lyricsList = const [
        "",
        "",
        "A???????????????1",
        "A???????????????2",
        "B???????????????",
        "???????????????",
        "????????????????????????????????????????????????????????????????????????",
      ];

      List<String> rhythmList = const [
        "4/4",
        "4/4",
        "4/4",
        "4/4",
        "4/4",
        "4/4",
        "4/4",
      ];

      List<String> separation = const [
        "Intro",
        "Intro",
        "A",
        "A",
        "B",
        "??????",
        "??????",
      ];
      FirebaseFirestore.instance.collection("Songs").add({
        "title": "???????????????",
        "bpm": 120,
        "key": "C / Am",
        "artist": "??????????????????????????????",
        "userID": uid,
        "memberID": [uid],
        "codeList": codeList,
        "lyricsList": lyricsList,
        "rhythmList": rhythmList,
        "separation": separation,
        "createdAt": DateTime.now(),
        "updatedAt": DateTime.now(),
      });
    }

    final _scrollController = ScrollController();
    if (Provider.of<AuthModel>(context, listen: false).loggedIn) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Songs')
            .where("memberID",
                arrayContains:
                    Provider.of<AuthModel>(context, listen: false).user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Text(''),
                ]));
          }
          if (snapshot.data.docs.length == 0) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Text('????????????????????????????????????'),
                  TextButton(
                      onPressed: () {
                        createSong();
                      },
                      child: const Text("????????????????????????????????????"))
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
                        caption: '??????',
                        color: Theme.of(context).colorScheme.error,
                        icon: Icons.delete,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                    title: const Text("??????"),
                                    content:
                                        Text("${doc["title"]}????????????????????????????????????"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("???????????????"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("OK"),
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
                        // print(doc["bpm"]);
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
                      AnchoredAdaptiveBanner(),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0),
                          child: TextField(
                            controller: _textEditingController,
                            onChanged: (text) {
                              setState(() {
                                searchText = text;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: "?????????????????????",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _textEditingController.clear();
                                  setState(() {
                                    searchText = "";
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          )),
                      ListView(
                        padding: const EdgeInsets.all(12.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: songsList,
                      )
                    ])));
          }
        },
      );
    } else {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            const Text('?????????????????????????????????'),
            OutlinedButton(
              child: const Text('??????????????????'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true, builder: (context) => LoginForm()));
              },
            )
          ]));
    }
  }
}
