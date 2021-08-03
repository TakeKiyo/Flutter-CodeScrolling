import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';
import 'detail_page.dart';

class DetailEditPage extends StatefulWidget {
  @override
  final int bpm;
  final String title;
  final String docId;
  final String codeList;

  DetailEditPage({this.bpm, this.title, this.docId, this.codeList});
  _DetailEditForm createState() => _DetailEditForm();
}

class _DetailEditForm extends State<DetailEditPage> {
  List<List<String>> _codeListState;
  List<List<String>> get codeListState => _codeListState;
  List<List<String>> addedList = [];

  Widget getCodeListWidgets(List<String> strings, int listIndex) {
    List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      list.add(Flexible(
          child: TextField(
        textAlign: TextAlign.center,
        controller: TextEditingController(text: strings[i]),
        onChanged: (text) {
          _codeListState[listIndex][i] = text;
        },
      )));
      list.add(Text("|"));
    }
    return new Row(children: list);
  }

  List<String> formatCodeList(List<List<String>> codeList) {
    List<String> formattedCodeList = [];
    for (int i = 0; i < codeListState.length; i++) {
      List<String> oneLineCodeList = codeListState[i];
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

  void editCodeList(String docId) async {
    FirebaseFirestore.instance.collection("Songs").doc(docId).update({
      "codeList": formatCodeList(codeListState),
    });
    Navigator.of(context).pop(
      MaterialPageRoute(builder: (context) {
        return DetailPage();
      }),
    );
  }

  void addLine() {
    setState(() {
      addedList.add(["", "", "", ""]);
    });
  }

  @override
  Widget build(BuildContext context) {
    _codeListState = [];
    List<String> splittedCodeList = widget.codeList.split("¥");
    splittedCodeList = splittedCodeList.sublist(0, splittedCodeList.length - 1);
    for (int i = 0; i < splittedCodeList.length; i++) {
      List<String> oneLineCode = splittedCodeList[i].split(",");
      List<String> tmp = [];
      for (int j = 0; j < oneLineCode.length; j++) {
        tmp.add(oneLineCode[j]);
      }
      _codeListState.add(tmp);
    }
    for (int i = 0; i < addedList.length; i++) {
      List<String> oneLineCode = addedList[i];
      List<String> tmp = [];
      for (int j = 0; j < oneLineCode.length; j++) {
        tmp.add(oneLineCode[j]);
      }
      _codeListState.add(tmp);
    }
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
              for (int idx = 0; idx < codeListState.length; idx++)
                getCodeListWidgets(codeListState[idx], idx),
              RaisedButton(
                child: const Text('小節を追加'),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  addLine();
                },
              ),
              RaisedButton(
                child: const Text('編集を終了'),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  editCodeList(widget.docId);
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
