import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:provider/provider.dart';

import '../custom_keyboard.dart';
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
    final _safeAreaHeight = MediaQuery.of(context).padding.bottom;

    Widget getCodeListWidgets(List<String> strings, int listIndex) {
      final eModel = Provider.of<EditingSongModel>(context, listen: false);
      List<Widget> list = [];

      for (var i = 0; i < strings.length; i++) {
        FocusNode _focusNode = FocusNode();
        _focusNode.addListener(() {
          if (_focusNode.hasFocus) {
            eModel.controller = strings[i];
            eModel.controlBarIdx = listIndex;
            eModel.controlTimeIdx = i;
            print(strings[i]);
          }
        });
        list.add(Flexible(
            child: TextField(
          textAlign: TextAlign.center,
          controller: TextEditingController(text: strings[i]),
          focusNode: _focusNode,
          onChanged: (text) {
            eModel.editCodeList(text, listIndex, i);
          },
        )));
        list.add(Text("|"));
      }
      list.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            eModel.deleteOneLine(listIndex);
          }));
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
        body: Builder(
            builder: (context) => Container(
                child: Scrollbar(
                    isAlwaysShown: true,
                    thickness: 8.0,
                    hoverThickness: 12.0,
                    child: SingleChildScrollView(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("コードの編集"),
                          for (int idx = 0; idx < model.codeList.length; idx++)
                            getCodeListWidgets(model.codeList[idx], idx),
                          ElevatedButton(
                            child: const Text('小節を追加',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange),
                            onPressed: () {
                              model.addEmptyList();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('編集を終了',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange),
                            onPressed: () {
                              submitCodeList(docId);
                            },
                          ),
                          TextButton(
                            child: Text("CustomKeyを表示",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () => Scaffold.of(context)
                                .showBottomSheet<void>((BuildContext context) {
                              return CustomKeyboard(
                                onTextInput: (myText) {
                                  Provider.of<EditingSongModel>(context,
                                          listen: false)
                                      .insertText(myText);
                                },
                                onBackspace: Provider.of<EditingSongModel>(
                                        context,
                                        listen: false)
                                    .backspace,
                                safeAreaHeight: _safeAreaHeight,
                              );
                            }),
                          ),
                        ],
                      )),
                    )))),
        //bottomSheet: CustomKeyboard(),
      );
    });
  }
}
