import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import 'detail_bottom_bar.dart';
import 'detail_page.dart';
import 'settings_drawer.dart';

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

class TabView extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;
  final String artist;
  final String songKey;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabView(
      {Key key, this.bpm, this.title, this.artist, this.songKey, this.docId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TabInfo> _tabs = [
      TabInfo(
          "CODE",
          DetailPage(
              bpm: bpm,
              title: title,
              artist: artist,
              songKey: songKey,
              docId: docId)),
      TabInfo(
          "Lyrics",
          DetailPage(
              bpm: bpm,
              title: title,
              artist: artist,
              songKey: songKey,
              docId: docId)),
    ];

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<MetronomeModel>(context, listen: false).forceStop();
              }),
          title: Text('Tab Controller'),
          bottom: PreferredSize(
            child: TabBar(
              tabs: _tabs.map((TabInfo tab) {
                return Tab(text: tab.label);
              }).toList(),
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  final data = ClipboardData(text: docId);
                  await Clipboard.setData(data);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('曲のIDをコピーしました。\n友達に送って曲を共有しましょう。'),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                    ),
                  );
                }),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                }),
          ],
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
        bottomNavigationBar: detailBottomBar(context),
        endDrawer: settingsDrawer(context, bpm, title, artist, songKey, docId),
      ),
    );
  }
}
