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

    void _showCustomKeyboard(context) {
      Scaffold.of(context).showBottomSheet((BuildContext context) {
        return CustomKeyboard(
          onTextInput: (myText) {
            Provider.of<EditingSongModel>(context, listen: false)
                .insertText(myText);
          },
          onBackspace:
              Provider.of<EditingSongModel>(context, listen: false).backspace,
          safeAreaHeight: _safeAreaHeight,
        );
      });
    }

    Widget getCodeListWidgets(context, List<String> strings, int listIndex,
        List<String> separationList) {
      List<Widget> separationText = [];

      if (listIndex == 0) {
        separationText.add(Text(separationList[listIndex]));
      } else {
        if (separationList[listIndex] != separationList[listIndex - 1]) {
          separationText.add(Text(separationList[listIndex]));
        } else {
          separationText.add(Text(""));
        }
      }

      List<Widget> list = [];
      for (var i = 0; i < strings.length; i++) {
        final _controller = TextEditingController(text: strings[i]);

        list.add(Flexible(
            child: TextField(
          showCursor: true,
          readOnly: true,
          onTap: () {
            if (!Provider.of<EditingSongModel>(context, listen: false)
                .keyboardIsOpening) {
              _showCustomKeyboard(context);
              Provider.of<EditingSongModel>(context, listen: false)
                  .openKeyboard();
            }
            Provider.of<EditingSongModel>(context, listen: false)
                .changeTextController(_controller);
            Provider.of<EditingSongModel>(context, listen: false)
                .controlBarIdx = listIndex;
            Provider.of<EditingSongModel>(context, listen: false)
                .controlTimeIdx = i;
          },
          textAlign: TextAlign.center,
          controller: _controller,
          onChanged: (text) {
            Provider.of<EditingSongModel>(context, listen: false)
                .editCodeList(text, listIndex, i);
          },
        )));
        list.add(Text("|"));
      }
      list.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Provider.of<EditingSongModel>(context, listen: false)
                .deleteOneLine(listIndex);
          }));
      return Column(children: <Widget>[
        Row(children: separationText),
        Row(children: list)
      ]);
    }

    void submitCodeList(String docId) async {
      FirebaseFirestore.instance.collection("Songs").doc(docId).update({
        "codeList": formatCodeList(
            Provider.of<EditingSongModel>(context, listen: false).codeList),
        "separation": Provider.of<EditingSongModel>(context, listen: false)
            .separationList,
        "updatedAt": DateTime.now(),
      });
      Navigator.of(context).pop(
        MaterialPageRoute(builder: (context) {
          return DetailPage();
        }),
      );
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Provider.of<EditingSongModel>(context, listen: false)
                    .closeKeyboard();
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
                  child: Padding(
                    padding: bottomPadding(context),
                    child: SingleChildScrollView(
                      child: Center(child:
                          Consumer<EditingSongModel>(builder: (_, model, __) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("コードの編集"),
                            for (int idx = 0;
                                idx < model.codeList.length;
                                idx++)
                              getCodeListWidgets(context, model.codeList[idx],
                                  idx, model.separationList),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<String>(
                                            value: model.selectedSeparation,
                                            elevation: 16,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            onChanged: (String newValue) {
                                              model.setSelectedSeparation(
                                                  newValue);
                                            },
                                            items: <String>[
                                              "　A",
                                              "　B",
                                              "　C",
                                              "サビ"
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value));
                                            }).toList(),
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<int>(
                                            value: model.selectedBeatCount,
                                            elevation: 16,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            onChanged: (int newValue) {
                                              model.setSelectedBeatCount(
                                                  newValue);
                                            },
                                            items: <int>[1, 2, 3, 4, 5, 6]
                                                .map<DropdownMenuItem<int>>(
                                                    (int value) {
                                              return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(
                                                      value.toString() + '拍'));
                                            }).toList(),
                                          ))),
                                  ElevatedButton(
                                    child: const Text('小節を追加',
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.orange),
                                    onPressed: () {
                                      model.addEmptyList();
                                    },
                                  ),
                                ]),
                            ElevatedButton(
                              child: const Text('編集を終了',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange),
                              onPressed: () {
                                model.closeKeyboard();
                                submitCodeList(docId);
                              },
                            ),
                          ],
                        );
                      })),
                    ),
                  ))),
          //bottomSheet: CustomKeyboard(),
        ));
  }
}

EdgeInsets bottomPadding(context) {
  return EdgeInsets.only(
      top: 16.0,
      left: 24.0,
      right: 16.0,
      bottom: Provider.of<EditingSongModel>(context).keyboardBottomSpace);
}
