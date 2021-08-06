import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/metronome_model.dart';

Drawer settingsDrawer(BuildContext context, MetronomeModel model, int bpm,
    String title, String docId) {
  final double titleTextFont = 16;
  final insertPadding = Padding(padding: EdgeInsets.all(10));

  return Drawer(
    child: Container(
      padding: EdgeInsets.all(25),
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          Text(
            "曲情報",
            style: TextStyle(
              fontSize: titleTextFont,
              color: Colors.white,
            ),
          ),
          ListTile(
            tileColor: Theme.of(context).primaryColorDark,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("曲名：" + title, style: TextStyle(color: Colors.white)),
                Text("BPM：" + bpm.toString(),
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            onTap: () {
              print("Information");
              //TODO ボタンを押したら情報変更画面
            },
          ),
          insertPadding,
          Text(
            "メトロノームのサウンド",
            style: TextStyle(
              fontSize: titleTextFont,
              color: Colors.white,
            ),
          ),
          ListTile(
              tileColor: Theme.of(context).primaryColorDark,
              title: Text(model.metronomeSound,
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                print("Metronome Sound");
                //TODO
              }),
          insertPadding,
          Text(
            "カウントイン",
            style: TextStyle(
              fontSize: titleTextFont,
              color: Colors.white,
            ),
          ),
          ListTile(
              tileColor: Theme.of(context).primaryColorDark,
              title: Text("回数：" + model.countInTimes.toString(),
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                print("Count-in Times");
                //TODO
              }),
          insertPadding,
          ElevatedButton(
            child: Text("曲を削除する", style: TextStyle(color: Colors.red)),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColorLight),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: Text("確認"),
                        content: Text(title + "を削除してもよいですか？"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("キャンセル"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                              child: Text("OK"),
                              onPressed: () async {
                                await Navigator.popUntil(context,
                                    (Route<dynamic> route) => route.isFirst);
                                FirebaseFirestore.instance
                                    .collection('Songs')
                                    .doc(docId)
                                    .delete();
                              }),
                        ],
                      ));
            },
          ),
        ],
      ),
    ),
  );
}
