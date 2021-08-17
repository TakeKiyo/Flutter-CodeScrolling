import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/detail_page/scrollable_page.dart';
import 'package:my_app/pages/detail_page/settings_drawer.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import '../export_song.dart';
import 'detail_bottom_bar.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DetailPage({Key key, this.bpm, this.title, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<MetronomeModel>(context, listen: false).forceStop();
            }),
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return ExportSong(docId: docId);
                  }),
                );
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              }),
        ],
      ),
      body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Songs')
                  .doc(docId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("Loading"));
                }
                var songDocument = snapshot.data;
                var codeList = songDocument["codeList"].cast<String>();
                // separationがあるか判定
                Map<String, dynamic> dataMap =
                    songDocument.data() as Map<String, dynamic>;
                List<String> separation;
                if (dataMap.containsKey('separation')) {
                  separation = songDocument["separation"].cast<String>();
                } else {
                  separation = [];
                }
                return ScrollablePage(codeList, bpm, title, docId, separation);
              })),
      bottomNavigationBar: detailBottomBar(context),
      endDrawer: settingsDrawer(context, bpm, title, docId),
    );
  }
}
