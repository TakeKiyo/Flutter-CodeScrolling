import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/detail_page/scrollable_page.dart';
import 'package:my_app/pages/detail_page/settings_drawer.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_bpm_model.dart';
import 'detail_bottom_bar.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DetailPage({Key key, this.bpm, this.title, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeBpmModel>(builder: (_, model, __) {
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
                  return ScrollablePage(codeList, bpm, title, docId);
                })),
        bottomNavigationBar: detailBottomBar(context, model),
        endDrawer: settingsDrawer(context, model, bpm, title, docId),
      );
    });
  }
}
