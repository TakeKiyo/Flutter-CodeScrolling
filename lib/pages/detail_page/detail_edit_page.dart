import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';

class DetailEditPage extends StatefulWidget {
  @override
  final int bpm;
  final String title;
  final String docId;

  DetailEditPage({this.bpm, this.title, this.docId});
  _DetailEditForm createState() => _DetailEditForm();
}

class _DetailEditForm extends State<DetailEditPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                model.forceStop();
              }),
          title: Text("編集ページ"),
          actions: <Widget>[],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("コードの編集"),
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Songs')
                          .doc(widget.docId)
                          .snapshots(),
                      builder:
                          // ignore: missing_return
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading");
                        }
                        var songDocument = snapshot.data;
                        if (songDocument["codeList"].length == 0) {
                          return Text("まだコードは追加されていません");
                        } else {
                          var codeList = songDocument["codeList"];
                          String concatenatedCode = "";

                          for (int idx = 0; idx < codeList.length; idx++) {
                            String oneLineCode = codeList[idx];
                            List<String> splitedOneLineCode =
                                oneLineCode.split(",");
                            print(splitedOneLineCode);
                            for (int i = 0;
                                i < splitedOneLineCode.length;
                                i++) {
                              concatenatedCode += splitedOneLineCode[i];
                              if (i == splitedOneLineCode.length - 1) {
                                concatenatedCode += "\n";
                              } else {
                                concatenatedCode += " | ";
                              }
                            }
                          }
                          return Text(concatenatedCode);
                        }
                      }))
            ],
          ),
        ),
        bottomNavigationBar: detailBottomBar(context, model),
      );
    });
  }
}
