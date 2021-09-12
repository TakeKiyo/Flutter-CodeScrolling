import 'package:flutter/material.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import '../export_song.dart';
import 'detail_bottom_bar.dart';
import 'detail_page.dart';
import 'lyrics_page.dart';
import 'settings_drawer.dart';

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

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
    final List<TabInfo> _tabs = [
      TabInfo(
          "CODE",
          DetailPage(
              bpm: widget.bpm,
              title: widget.title,
              artist: widget.artist,
              songKey: widget.songKey,
              docId: widget.docId)),
      TabInfo(
          "Lyrics",
          LyricsPage(
              bpm: widget.bpm,
              title: widget.title,
              artist: widget.artist,
              songKey: widget.songKey,
              docId: widget.docId)),
    ];

    return DefaultTabController(
      length: _tabs.length,
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
            tabs: _tabs.map((TabInfo tab) {
              return Tab(text: tab.label);
            }).toList(),
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
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
        bottomNavigationBar: detailBottomBar(context),
        endDrawer: settingsDrawer(context, widget.bpm, widget.title,
            widget.artist, widget.songKey, widget.docId),
      ),
    );
  }
}
