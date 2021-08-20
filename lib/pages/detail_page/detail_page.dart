import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/detail_page/scrollable_page.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;
  final String artist;
  final String songKey;

  DetailPage(
      {Key key, this.bpm, this.title, this.artist, this.songKey, this.docId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              List<String> rhythmList;
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
              return ScrollablePage(
                  codeList, bpm, title, docId, separation, rhythmList);
            }));
  }
}
