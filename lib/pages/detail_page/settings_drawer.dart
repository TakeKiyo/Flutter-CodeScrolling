import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/metronome_model.dart';
import '../../pages/custom_keyboard.dart';

Drawer settingsDrawer(
    BuildContext context, MetronomeModel model, int bpm, String title) {
  final double titleTextFont = 16;

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
          Padding(padding: EdgeInsets.all(10)),
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
          Padding(padding: EdgeInsets.all(10)),
          TextButton(
              child: Text("CustomKey", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return KeyboardDemo();
                  }),
                );
              }),
        ],
      ),
    ),
  );
}
