import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';

class DetailEditPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;

  DetailEditPage({this.bpm, this.title, this.docId});

  List<String> formatCodeList(List<List<String>> codeList) {
    List<String> formattedCodeList = [];
    for (int i = 0; i < codeList.length; i++) {
      List<String> oneLineCodeList = codeList[i];
      String tmp = "";
      for (int j = 0; j < oneLineCodeList.length; j++) {
        tmp += oneLineCodeList[j];
        if (j != oneLineCodeList.length - 1) {
          tmp += ",";
        }
      }
      formattedCodeList.add(tmp);
    }
    return formattedCodeList;
  }

  @override
  Widget build(BuildContext context) {
    Widget getCodeListWidgets(List<String> strings, int listIndex) {
      List<Widget> list = [];
      for (var i = 0; i < strings.length; i++) {
        list.add(Flexible(
            child: TextField(
          textAlign: TextAlign.center,
          controller: TextEditingController(text: strings[i]),
          onChanged: (text) {
            Provider.of<EditingSongModel>(context, listen: false)
                .editCodeList(text, listIndex, i);
          },
        )));
        list.add(Text("|"));
      }
      return new Row(children: list);
    }

    void submitCodeList(String docId) async {
      FirebaseFirestore.instance.collection("Songs").doc(docId).update({
        "codeList": formatCodeList(
            Provider.of<EditingSongModel>(context, listen: false).codeList),
        "updatedAt": DateTime.now(),
      });
      Navigator.of(context).pop(
        MaterialPageRoute(builder: (context) {
          return DetailPage();
        }),
      );
    }

    return Consumer<EditingSongModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text("編集ページ"),
          actions: <Widget>[],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("コードの編集"),
              for (int idx = 0; idx < model.codeList.length; idx++)
                getCodeListWidgets(model.codeList[idx], idx),
              ElevatedButton(
                child:
                    const Text('小節を追加', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                onPressed: () {
                  model.addEmptyList();
                },
              ),
              ElevatedButton(
                child:
                    const Text('編集を終了', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                onPressed: () {
                  submitCodeList(docId);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
