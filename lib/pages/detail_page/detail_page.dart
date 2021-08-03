import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';
import 'detail_edit_page.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;

  DetailPage({Key key, this.bpm, this.title, this.docId}) : super(key: key);

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
          title: Text(title),
          actions: <Widget>[],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Songs')
                          .doc(docId)
                          .snapshots(),
                      builder:
                          // ignore: missing_return
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading");
                        }
                        var songDocument = snapshot.data;
                        if (songDocument["codeList"].length == 0) {
                          return Column(
                            children: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Provider.of<MetronomeModel>(context,
                                            listen: false)
                                        .tempoCount = bpm;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return DetailEditPage(
                                            bpm: bpm,
                                            title: title,
                                            docId: docId,
                                            codeList: "",
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("コードを編集する")),
                              Text("まだコードは追加されていません")
                            ],
                          );
                        } else {
                          var codeList = songDocument["codeList"];
                          String concatenatedCode = "";
                          String codeListState = "";

                          for (int idx = 0; idx < codeList.length; idx++) {
                            String oneLineCode = codeList[idx];
                            List<String> splitedOneLineCode =
                                oneLineCode.split(",");
                            for (int i = 0;
                                i < splitedOneLineCode.length;
                                i++) {
                              concatenatedCode += splitedOneLineCode[i];
                              codeListState += splitedOneLineCode[i];
                              if (i == splitedOneLineCode.length - 1) {
                                concatenatedCode += "\n";
                                codeListState += "¥";
                              } else {
                                concatenatedCode += " | ";
                                codeListState += ",";
                              }
                            }
                          }
                          return Column(
                            children: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Provider.of<MetronomeModel>(context,
                                            listen: false)
                                        .tempoCount = bpm;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return DetailEditPage(
                                            bpm: bpm,
                                            title: title,
                                            docId: docId,
                                            codeList: codeListState,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("コードを編集する")),
                              Text(concatenatedCode),
                            ],
                          );
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
