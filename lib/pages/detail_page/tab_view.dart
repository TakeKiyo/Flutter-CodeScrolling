import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import '../export_song.dart';
import 'chords_page.dart';
import 'detail_bottom_bar.dart';
import 'detail_edit_page.dart';
import 'lyrics_page.dart';
import 'setting_song_information.dart';

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
  @override
  Widget build(BuildContext context) {
    Future<bool> _willPopCallback() async {
      return true;
    }

    return DefaultTabController(
      length: 2,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Songs')
              .doc(widget.docId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading"));
            }
            var songDocument = snapshot.data;
            var chordList = songDocument["codeList"].cast<String>();
            // separationがあるか判定
            Map<String, dynamic> dataMap =
                songDocument.data() as Map<String, dynamic>;
            List<String> separationList;
            List<String> rhythmList;
            List<String> lyricsList;
            if (dataMap.containsKey('separation')) {
              separationList = songDocument["separation"].cast<String>();
            } else {
              separationList = [];
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
            return WillPopScope(
              onWillPop: _willPopCallback,
              child: Scaffold(
                appBar: !Provider.of<MetronomeModel>(context).isPlaying
                    ? AppBar(
                        leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Provider.of<MetronomeModel>(context,
                                      listen: false)
                                  .forceStop();
                            }),
                        bottom: TabBar(
                          labelColor:
                              Theme.of(context).textTheme.headline6.color,
                          indicatorColor: Theme.of(context).primaryColor,
                          tabs: [Tab(text: "Chord"), Tab(text: "Lyrics")],
                        ),
                        actions: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.format_size),
                              onPressed: () {}),
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Provider.of<MetronomeModel>(context,
                                        listen: false)
                                    .tempoCount = widget.bpm;
                                Provider.of<EditingSongModel>(context,
                                        listen: false)
                                    .chordList = chordList;
                                Provider.of<EditingSongModel>(context,
                                        listen: false)
                                    .separationList = separationList;
                                Provider.of<EditingSongModel>(context,
                                        listen: false)
                                    .rhythmList = rhythmList;
                                Provider.of<EditingSongModel>(context,
                                        listen: false)
                                    .lyricsList = lyricsList;
                                if (DefaultTabController.of(context).index ==
                                    0) {
                                  if (Provider.of<EditingSongModel>(context,
                                          listen: false)
                                      .lyricsDisplayed) {
                                    Provider.of<EditingSongModel>(context,
                                            listen: false)
                                        .setDisplayType("both");
                                  } else {
                                    Provider.of<EditingSongModel>(context,
                                            listen: false)
                                        .setDisplayType("chord");
                                  }
                                } else {
                                  Provider.of<EditingSongModel>(context,
                                          listen: false)
                                      .setDisplayType("lyrics");
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return DetailEditPage(
                                        bpm: widget.bpm,
                                        title: widget.title,
                                        docId: widget.docId,
                                      );
                                    },
                                  ),
                                );
                              }),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) {
                                        return SettingSongInfo(
                                          bpm: widget.bpm,
                                          title: widget.title,
                                          docId: widget.docId,
                                          songKey: widget.songKey,
                                          artist: widget.artist,
                                        );
                                      }),
                                );
                              }),
                        ],
                      )
                    : AppBar(
                        automaticallyImplyLeading: false,
                        flexibleSpace: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TabBar(
                                labelColor:
                                    Theme.of(context).textTheme.headline6.color,
                                indicatorColor: Theme.of(context).primaryColor,
                                tabs: [Tab(text: "Chord"), Tab(text: "Lyrics")],
                              ),
                            ]),
                      ),
                body: TabBarView(children: [
                  ChordsPage(
                      chordList: chordList,
                      bpm: widget.bpm,
                      title: widget.title,
                      docId: widget.docId,
                      artist: widget.artist,
                      separationList: separationList,
                      rhythmList: rhythmList,
                      lyricsList: lyricsList),
                  LyricsPage(
                      chordList: chordList,
                      bpm: widget.bpm,
                      title: widget.title,
                      docId: widget.docId,
                      artist: widget.artist,
                      separationList: separationList,
                      rhythmList: rhythmList,
                      lyricsList: lyricsList),
                ]),
                bottomNavigationBar: Visibility(
                    visible: chordList.length != 0,
                    child: detailBottomBar(context)),
              ),
            );
          }),
    );
  }
}
