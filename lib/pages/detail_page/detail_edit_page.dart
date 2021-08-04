import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';

class DetailEditPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;
  final String codeList;

  DetailEditPage({this.bpm, this.title, this.docId, this.codeList});

  Widget getCodeListWidgets(List<String> strings, int listIndex) {
    List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      list.add(Flexible(
          child: TextField(
        textAlign: TextAlign.center,
        controller: TextEditingController(text: strings[i]),
        onChanged: (text) {
          // _codeListState[listIndex][i] = text;
        },
      )));
      list.add(Text("|"));
    }
    return new Row(children: list);
  }

  List<String> formatCodeList(List<List<String>> codeList) {
    // List<String> formattedCodeList = [];
    // for (int i = 0; i < codeListState.length; i++) {
    //   List<String> oneLineCodeList = codeListState[i];
    //   String tmp = "";
    //   for (int j = 0; j < oneLineCodeList.length; j++) {
    //     tmp += oneLineCodeList[j];
    //     if (j != oneLineCodeList.length - 1) {
    //       tmp += ",";
    //     }
    //   }
    //   formattedCodeList.add(tmp);
    // }
    // return formattedCodeList;
  }

  void editCodeList(String docId) async {
    // FirebaseFirestore.instance.collection("Songs").doc(docId).update({
    //   "codeList": formatCodeList(codeListState),
    // });
    // Navigator.of(context).pop(
    //   MaterialPageRoute(builder: (context) {
    //     return DetailPage();
    //   }),
    // );
  }

  // void addLine() {
  //   setState(() {
  //     addedList.add(["", "", "", ""]);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print("build");
    print(Provider.of<MetronomeModel>(context).codeList);

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
                  editCodeList(docId);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: detailBottomBar(context, model),
      );
    });
  }
}
