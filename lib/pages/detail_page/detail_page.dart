import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/pages/detail_page/scrollable_page.dart';
import 'package:my_app/pages/detail_page/settings_drawer.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';
import 'detail_edit_page.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DetailPage({Key key, this.bpm, this.title, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                model.forceStop();
              }),
          title: Text(title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                }),
          ],
        ),
        body: Container(
            // child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Songs')
                    .doc(docId)
                    .snapshots(),
                builder:
                    // ignore: missing_return
                    (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text("Loading"));
                  }
                  var songDocument = snapshot.data;
                  if (songDocument["codeList"].length == 0) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                            onPressed: () {
                              Provider.of<MetronomeModel>(context,
                                      listen: false)
                                  .tempoCount = bpm;
                              Provider.of<EditingSongModel>(context,
                                      listen: false)
                                  .codeList = [];
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DetailEditPage(
                                      bpm: bpm,
                                      title: title,
                                      docId: docId,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text("コードを編集する")),
                        Text("まだコードは追加されていません")
                      ],
                    ));
                  } else {
                    var codeList = songDocument["codeList"].cast<String>();
                    return ScrollablePage(codeList, bpm, title, docId);
                  }
                })),
        bottomNavigationBar: detailBottomBar(context, model),
        endDrawer: settingsDrawer(context, model, bpm, title, docId),
      );
    });
  }
}
