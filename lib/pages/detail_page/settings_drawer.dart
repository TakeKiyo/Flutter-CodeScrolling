import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import '../edit_song_info.dart';

Drawer settingsDrawer(BuildContext context, int bpm, String title,
    String artist, String songKey, String docId) {
  const titleTextFont = 16.0;
  final insertPadding = const Padding(padding: EdgeInsets.all(10));

  return Drawer(
    child: Material(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            const Text(
              "曲情報を編集する",
              style: TextStyle(
                fontSize: titleTextFont,
              ),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0)),
              tileColor: Colors.grey.withOpacity(0.5),
              title: Text("曲名： $title\n"
                  "アーティスト： $artist\n"
                  "キー： $songKey\n"
                  "BPM： $bpm"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return EditSongInfo(
                          title: title,
                          artist: artist,
                          bpm: bpm,
                          songKey: songKey,
                          docId: docId,
                        );
                      }),
                );
              },
            ),
            insertPadding,
            const Text(
              "メトロノームのサウンド",
              style: TextStyle(
                fontSize: titleTextFont,
              ),
            ),
            ButtonTheme(
                alignedDropdown: true,
                child: Consumer<MetronomeModel>(builder: (_, model, __) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(9)),
                      child: Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            dropdownColor: Colors.grey,
                            isExpanded: true,
                            value: model.metronomeSoundsList
                                .indexOf(model.metronomeSound),
                            elevation: 16,
                            onChanged: (int newValue) {
                              model.metronomeSound = newValue;
                            },
                            items: const <int>[0, 1, 2]
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(model.metronomeSoundsList[value]
                                      .replaceAll("sounds/", "")
                                      .replaceAll(".mp3", "")));
                            }).toList(),
                          ),
                        ),
                      ));
                })),
            insertPadding,
            const Text(
              "カウントイン",
              style: TextStyle(
                fontSize: titleTextFont,
              ),
            ),
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                tileColor: Colors.grey.withOpacity(0.5),
                title: Consumer<MetronomeModel>(builder: (_, model, __) {
                  return Text(
                    "回数：" + model.countInTimes.toString(),
                  );
                }),
                onTap: () {
                  print("Count-in Times");
                  //TODO
                }),
            insertPadding,
            ElevatedButton(
              child: const Text("曲を削除する"),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                          title: const Text("確認"),
                          content: Text(title + "を削除してもよいですか？"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("キャンセル"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                                child: const Text("OK"),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  await Future.delayed(Duration(seconds: 1));
                                  String uid = Provider.of<AuthModel>(context,
                                          listen: false)
                                      .user
                                      .uid;
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
                                      memberIDList.remove(uid);
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
