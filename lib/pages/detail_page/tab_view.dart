import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import '../export_song.dart';
import 'detail_bottom_bar.dart';
import 'lyrics_page.dart';
import 'scrollable_page.dart';
import 'settings_drawer.dart';

class TabView extends StatefulWidget {
  final int bpm;
  final String title;
  final String docId;
  final String artist;
  final String songKey;

  TabView(
      {Key key, this.bpm, this.title, this.artist, this.songKey, this.docId})
      : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<MetronomeModel>(context, listen: false).forceStop();
              }),
          title: Text(widget.title),
          bottom: TabBar(
            labelColor: Theme.of(context).textTheme.headline6.color,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [Tab(text: "Code"), Tab(text: "Lyrics")],
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ExportSong(docId: widget.docId);
                    }),
                  );
                }),
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                }),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Songs')
                .doc(widget.docId)
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
              List<String> rhythmList;
              List<String> lyricsList;
              if (dataMap.containsKey('separation')) {
                separation = songDocument["separation"].cast<String>();
              } else {
                separation = [];
              }
              if (dataMap.containsKey('rhythmList')) {
                rhythmList = songDocument["rhythmList"].cast<String>();
              } else {
                rhythmList = [];
              }
              if (dataMap.containsKey("lyricsList")) {
                lyricsList = songDocument["lyricsList"].cast<String>();
              } else {
                lyricsList = [];
              }
              return TabBarView(children: [
                ScrollablePage(
                    codeList: codeList,
                    bpm: widget.bpm,
                    title: widget.title,
                    docId: widget.docId,
                    separationList: separation,
                    rhythmList: rhythmList,
                    lyricsList: lyricsList),
                LyricsPage(
                    bpm: widget.bpm,
                    title: widget.title,
                    artist: widget.artist,
                    songKey: widget.songKey,
                    docId: widget.docId),
              ]);
            }),
        bottomNavigationBar: detailBottomBar(context),
        endDrawer: settingsDrawer(context, widget.bpm, widget.title,
            widget.artist, widget.songKey, widget.docId),
      ),
    );
  }
}
