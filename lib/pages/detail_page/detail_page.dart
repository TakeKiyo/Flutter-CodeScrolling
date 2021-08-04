import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/pages/detail_page/settings_drawer.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';
import 'detail_edit_page.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DetailPage({Key key, this.bpm, this.title, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getCodeListWidgets(List<String> strings, int listIndex) {
      List<Widget> list = [];
      for (var i = 0; i < strings.length; i++) {
        list.add(Flexible(
            child: TextField(
          enabled: false,
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

    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                model.forceStop();
              }),
          title: Text(title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                }),
          ],
        ),
        body: Container(
          child: Scrollbar(
              isAlwaysShown: true,
              thickness: 8.0,
              hoverThickness: 12.0,
              child: SingleChildScrollView(
                  child: Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Songs')
                              .doc(docId)
                              .snapshots(),
                          builder:
                              // ignore: missing_return
                              (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Loading");
                            }
                            var songDocument = snapshot.data;
                            if (songDocument["codeList"].length == 0) {
                              return Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<MetronomeModel>(context,
                                                listen: false)
                                            .tempoCount = bpm;
                                        Provider.of<EditingSongModel>(context,
                                                listen: false)
                                            .codeList = [];
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DetailEditPage(
                                                bpm: bpm,
                                                title: title,
                                                docId: docId,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text("コードを編集する")),
                                  Text("まだコードは追加されていません")
                                ],
                              ));
                            } else {
                              var codeList =
                                  songDocument["codeList"].cast<String>();
                              List<List<String>> codeListState = [];
                              for (int i = 0; i < codeList.length; i++) {
                                List<String> oneLineCode =
                                    codeList[i].split(",");
                                List<String> tmp = [];
                                for (int j = 0; j < oneLineCode.length; j++) {
                                  tmp.add(oneLineCode[j]);
                                }
                                codeListState.add(tmp);
                              }

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<MetronomeModel>(context,
                                                listen: false)
                                            .tempoCount = bpm;
                                        Provider.of<EditingSongModel>(context,
                                                listen: false)
                                            .codeList = codeList;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DetailEditPage(
                                                bpm: bpm,
                                                title: title,
                                                docId: docId,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text("コードを編集する")),
                                  for (int idx = 0;
                                      idx < codeListState.length;
                                      idx++)
                                    getCodeListWidgets(codeListState[idx], idx),
                                ],
                              );
                            }
                          })))),
        ),
        bottomNavigationBar: detailBottomBar(context, model),
        endDrawer: settingsDrawer(context, model, bpm, title),
      );
    });
  }
}
