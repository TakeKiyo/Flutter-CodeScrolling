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
        List<String> separationList, List<String> rhythmList) {
      List<Widget> separationText = [];
      List<Widget> lyrics = [];
      List<Widget> list = [];
      if (listIndex == 0) {
        separationText.add(Text(separationList[listIndex],
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black,
            )));
        list.add(Text(rhythmList[listIndex]));
      } else {
        if (separationList[listIndex] != separationList[listIndex - 1]) {
          separationText.add(Text(separationList[listIndex],
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black,
              )));
        } else {
          separationText.add(Text(""));
        }

        if (rhythmList[listIndex] != rhythmList[listIndex - 1]) {
          list.add(Text(rhythmList[listIndex]));
        } else {
          list.add(Padding(
            padding: const EdgeInsets.only(left: 24.0),
          ));
        }
      }
      final _lyricsController = TextEditingController(
          text: Provider.of<EditingSongModel>(context, listen: false)
              .lyricsList[listIndex]);
      _lyricsController.selection = TextSelection.fromPosition(
          TextPosition(offset: _lyricsController.text.length));
      lyrics.add(Flexible(
          child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 48.0),
              child: TextFormField(
                controller: _lyricsController,
                showCursor: true,
                maxLines: null,
                onTap: () {
                  if (Provider.of<EditingSongModel>(context, listen: false)
                      .keyboardIsOpening) {
                    Provider.of<EditingSongModel>(context, listen: false)
                        .closeKeyboard();
                  }
                  Provider.of<EditingSongModel>(context, listen: false)
                      .openNormalKeyboard();
                },
                onChanged: (text) {
                  Provider.of<EditingSongModel>(context, listen: false)
                      .editLyricsList(text, listIndex);
                },
              ))));

      for (var i = 0; i < strings.length; i++) {
        final _controller = TextEditingController(text: strings[i]);
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
        list.add(Flexible(
            child: TextField(
          showCursor: true,
          readOnly: true,
          onTap: () {
            if (Provider.of<EditingSongModel>(context, listen: false)
                .normalKeyboardIsOpen) {
              Provider.of<EditingSongModel>(context, listen: false)
                  .closeNormalKeyboard();
            }
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
          icon: Icon(Icons.more_vert),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("編集"),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: ListTile(
                        // ignore: missing_required_param
                        leading: IconButton(
                          icon: Icon(Icons.delete),
                        ),
                        title: Text('この行を削除する'),
                      ),
                      onPressed: () {
                        Provider.of<EditingSongModel>(context, listen: false)
                            .deleteOneLine(listIndex);
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: ListTile(
                        // ignore: missing_required_param
                        leading: IconButton(
                          icon: Icon(Icons.control_point),
                        ),
                        title: Text('この行を複製して追加'),
                      ),
                      onPressed: () {
                        Provider.of<EditingSongModel>(context, listen: false)
                            .duplicateList(listIndex);
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("戻る"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
          }));
      if (Provider.of<EditingSongModel>(context, listen: false).displayType ==
          "both") {
        return Column(children: <Widget>[
          Row(children: separationText),
          Row(children: lyrics),
          Row(children: list)
        ]);
      } else if (Provider.of<EditingSongModel>(context, listen: false)
              .displayType ==
          "code") {
        return Column(children: <Widget>[
          Row(children: separationText),
          Row(children: list)
        ]);
      } else {
        return Column(children: <Widget>[
          Row(children: separationText),
          Row(children: lyrics),
        ]);
      }
    }

    void submitCodeList(String docId) async {
      FirebaseFirestore.instance.collection("Songs").doc(docId).update({
        "codeList": formatCodeList(
            Provider.of<EditingSongModel>(context, listen: false).codeList),
        "separation": Provider.of<EditingSongModel>(context, listen: false)
            .separationList,
        "rhythmList":
            Provider.of<EditingSongModel>(context, listen: false).rhythmList,
        "lyricsList":
            Provider.of<EditingSongModel>(context, listen: false).lyricsList,
        "updatedAt": DateTime.now(),
      });
      Navigator.of(context).pop(
        MaterialPageRoute(builder: (context) {
          return DetailPage();
        }),
      );
    }

    void showDisplayTypeDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("編集方法の選択"),
              children: <Widget>[
                // コンテンツ領域
                SimpleDialogOption(
                    onPressed: () => {
                          Navigator.pop(context),
                          Provider.of<EditingSongModel>(context, listen: false)
                              .setDisplayType("both")
                        },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("コードと歌詞を編集"),
                    )),
                SimpleDialogOption(
                    onPressed: () => {
                          Navigator.pop(context),
                          Provider.of<EditingSongModel>(context, listen: false)
                              .setDisplayType("code")
                        },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("コードのみ編集"),
                    )),

                SimpleDialogOption(
                    onPressed: () => {
                          Navigator.pop(context),
                          Provider.of<EditingSongModel>(context, listen: false)
                              .setDisplayType("lyrics")
                        },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("歌詞のみ編集"),
                    )),
              ],
            );
          });
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
              Provider.of<EditingSongModel>(context, listen: false)
                  .closeNormalKeyboard();
              Navigator.of(context).pop();
            }),
        title: Text("編集ページ"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDisplayTypeDialog();
              }),
        ],
      ),
      body: Builder(
          builder: (context) => GestureDetector(
                onTap: () => {
                  FocusScope.of(context).unfocus(),
                  Provider.of<EditingSongModel>(context, listen: false)
                      .closeNormalKeyboard(),
                },
                child: Container(
                    child: Scrollbar(
                        isAlwaysShown: true,
                        thickness: 8.0,
                        hoverThickness: 12.0,
                        child: Padding(
                          padding: bottomPadding(context),
                          child: SingleChildScrollView(
                            child: Center(child: Consumer<EditingSongModel>(
                                builder: (_, model, __) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        return showDisplayTypeDialog();
                                      },
                                      child: Text('編集方法の変更')),
                                  for (int idx = 0;
                                      idx < model.codeList.length;
                                      idx++)
                                    getCodeListWidgets(
                                        context,
                                        model.codeList[idx],
                                        idx,
                                        model.separationList,
                                        model.rhythmList),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<String>(
                                                  value:
                                                      model.selectedSeparation,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  onChanged: (String newValue) {
                                                    model.setSelectedSeparation(
                                                        newValue);
                                                  },
                                                  items: <String>[
                                                    "Intro",
                                                    "A",
                                                    "B",
                                                    "C",
                                                    "サビ"
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                            String>(
                                                        value: value,
                                                        child: Text(value));
                                                  }).toList(),
                                                ))),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<String>(
                                                  value: model.selectedRhythm,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  onChanged: (String newValue) {
                                                    model.setSelectedRhythm(
                                                        newValue);
                                                  },
                                                  items: <String>[
                                                    "4/4",
                                                    "3/4",
                                                    "2/4",
                                                    "6/8",
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                            String>(
                                                        value: value,
                                                        child: Text(value));
                                                  }).toList(),
                                                ))),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<int>(
                                                  value:
                                                      model.selectedBeatCount,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  onChanged: (int newValue) {
                                                    model.setSelectedBeatCount(
                                                        newValue);
                                                  },
                                                  items: <int>[
                                                    1,
                                                    2,
                                                    3,
                                                    4,
                                                    5,
                                                    6
                                                  ].map<DropdownMenuItem<int>>(
                                                      (int value) {
                                                    return DropdownMenuItem<
                                                            int>(
                                                        value: value,
                                                        child: Text(
                                                            value.toString() +
                                                                '小節'));
                                                  }).toList(),
                                                ))),
                                        ElevatedButton(
                                          child: const Text('追加',
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                                      FocusScope.of(context).unfocus();
                                      model.closeKeyboard();
                                      model.closeNormalKeyboard();
                                      submitCodeList(docId);
                                    },
                                  ),
                                ],
                              );
                            })),
                          ),
                        ))),
                //bottomSheet: CustomKeyboard(),
              )),
    );
  }
}

EdgeInsets bottomPadding(context) {
  return EdgeInsets.only(
      top: 24.0,
      left: 24.0,
      right: 8.0,
      bottom: Provider.of<EditingSongModel>(context).keyboardBottomSpace);
}
