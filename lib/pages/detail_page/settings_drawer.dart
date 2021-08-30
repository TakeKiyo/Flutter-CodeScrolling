import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';

Drawer settingsDrawer(BuildContext context, int bpm, String title,
    String artist, String songKey, String docId) {
  final double titleTextFont = 16;
  final insertPadding = Padding(padding: EdgeInsets.all(10));

  return Drawer(
    child: Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(25),
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
                  Text("アーティスト：" + artist,
                      style: TextStyle(color: Colors.white)),
                  Text("キー：" + songKey, style: TextStyle(color: Colors.white)),
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
            ButtonTheme(
                alignedDropdown: true,
                child: Consumer<MetronomeModel>(builder: (_, model, __) {
                  return Container(
                      color: Theme.of(context).primaryColorDark,
                      child: DropdownButton<int>(
                        isExpanded: true,
                        dropdownColor: Theme.of(context).primaryColorDark,
                        value: model.metronomeSoundsList
                            .indexOf(model.metronomeSound),
                        elevation: 16,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (int newValue) {
                          model.metronomeSound = newValue;
                        },
                        items: <int>[0, 1, 2]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                              value: value,
                              child: Text(model.metronomeSoundsList[value]
                                  .replaceAll("sounds/", "")
                                  .replaceAll(".mp3", "")));
                        }).toList(),
                      ));
                })),
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
                title: Consumer<MetronomeModel>(builder: (_, model, __) {
                  return Text("回数：" + model.countInTimes.toString(),
                      style: TextStyle(color: Colors.white));
                }),
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
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  await Future.delayed(Duration(seconds: 1));
                                  String udid = await FlutterUdid.udid;
                                  await FirebaseFirestore.instance
                                      .collection("Songs")
                                      .doc(docId)
                                      .get()
                                      .then(
                                          (DocumentSnapshot documentSnapshot) {
                                    var document =
                                        documentSnapshot.data() as Map;
                                    List<String> memberIDList =
                                        document["memberID"].cast<String>();
                                    if (memberIDList.length == 1) {
                                      FirebaseFirestore.instance
                                          .collection('Songs')
                                          .doc(docId)
                                          .delete();
                                    } else {
                                      memberIDList.remove(udid);
                                      FirebaseFirestore.instance
                                          .collection("Songs")
                                          .doc(docId)
                                          .update({
                                        "type": "removeMember",
                                        "memberID": memberIDList,
                                        "updatedAt": DateTime.now(),
                                      });
                                    }
                                  });
                                })
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    ),
  );
}
