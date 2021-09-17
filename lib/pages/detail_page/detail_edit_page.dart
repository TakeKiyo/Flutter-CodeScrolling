import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import './style/display_text_style.dart';
import '../custom_keyboard.dart';

class DetailEditPage extends StatefulWidget {
  final int bpm;
  final String title;
  final String docId;

  DetailEditPage({this.bpm, this.title, this.docId});

  _DetailEditPageState createState() => _DetailEditPageState();
}

class _DetailEditPageState extends State<DetailEditPage> {
  ScrollController _scrollController;
  List<GlobalKey> _globalLyricFormList = [];
  List<GlobalKey> _globalChordFormList = [];

  //should be called before re-build
  void _setTextFieldComponents() {
    //initialize
    _globalLyricFormList = [];
    _globalChordFormList = [];
    Provider.of<EditingSongModel>(context, listen: false).lyricControllerList =
        null;
    Provider.of<EditingSongModel>(context, listen: false).chordControllerList =
        null;

    //add GlobalKey
    for (int listIndex = 0;
        listIndex <
            Provider.of<EditingSongModel>(context, listen: false)
                .chordList
                .length;
        listIndex++) {
      _globalLyricFormList.add(GlobalKey<FormState>());
      _globalChordFormList.add(GlobalKey<FormState>());

      //add TextController
      Provider.of<EditingSongModel>(context, listen: false)
              .lyricControllerList =
          TextEditingController(
              text: Provider.of<EditingSongModel>(context, listen: false)
                  .lyricsList[listIndex]);

      Provider.of<EditingSongModel>(context, listen: false)
              .chordControllerList =
          List.generate(
              Provider.of<EditingSongModel>(context, listen: false)
                  .chordList[listIndex]
                  .length,
              (idx) => TextEditingController(
                  text: Provider.of<EditingSongModel>(context, listen: false)
                      .chordList[listIndex][idx]));
    }
  }

  double _getLyricLocale(int listIndex) {
    RenderBox box =
        _globalLyricFormList[listIndex].currentContext.findRenderObject();
    return box.localToGlobal(Offset.zero).dy;
  }

  double _getChordLocale(int listIndex) {
    RenderBox box =
        _globalChordFormList[listIndex].currentContext.findRenderObject();
    return box.localToGlobal(Offset.zero).dy;
  }

  //should be called after re-build
  void _setEachOffsetList() {
    Provider.of<EditingSongModel>(context, listen: false).chordFormOffsetList =
        -1;
    Provider.of<EditingSongModel>(context, listen: false).lyricFormOffsetList =
        -1;

    switch (Provider.of<EditingSongModel>(context, listen: false).displayType) {
      case "chord":
        for (int listIndex = 0;
            listIndex <
                Provider.of<EditingSongModel>(context, listen: false)
                    .chordList
                    .length;
            listIndex++)
          Provider.of<EditingSongModel>(context, listen: false)
              .chordFormOffsetList = _getChordLocale(listIndex);
        break;
      case "both":
        for (int listIndex = 0;
            listIndex <
                Provider.of<EditingSongModel>(context, listen: false)
                    .chordList
                    .length;
            listIndex++) {
          Provider.of<EditingSongModel>(context, listen: false)
              .chordFormOffsetList = _getChordLocale(listIndex);
          Provider.of<EditingSongModel>(context, listen: false)
              .lyricFormOffsetList = _getLyricLocale(listIndex);
        }
        break;
      case "lyrics":
        for (int listIndex = 0;
            listIndex <
                Provider.of<EditingSongModel>(context, listen: false)
                    .chordList
                    .length;
            listIndex++)
          Provider.of<EditingSongModel>(context, listen: false)
              .lyricFormOffsetList = _getLyricLocale(listIndex);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Provider.of<EditingSongModel>(context, listen: false).editScrollController =
        _scrollController;
    _setTextFieldComponents();
    WidgetsBinding.instance.addPostFrameCallback((cb) => _setEachOffsetList());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<String> formatChordList(List<List<String>> chordList) {
    List<String> formattedChordList = [];
    for (int i = 0; i < chordList.length; i++) {
      List<String> oneLineChordList = chordList[i];
      String tmp = "";
      for (int j = 0; j < oneLineChordList.length; j++) {
        tmp += oneLineChordList[j];
        if (j != oneLineChordList.length - 1) {
          tmp += ",";
        }
      }
      formattedChordList.add(tmp);
    }
    return formattedChordList;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EditingSongModel>(context, listen: false).deviceHeight =
        MediaQuery.of(context).size.height;

    void _showCustomKeyboard(context) {
      Scaffold.of(context)
          .showBottomSheet((context, {backgroundColor: Colors.transparent}) {
            return CustomKeyboard(
              onTextInput: (myText) {
                Provider.of<EditingSongModel>(context, listen: false)
                    .insertText(myText);
              },
              onBackspace: Provider.of<EditingSongModel>(context, listen: false)
                  .backspace,
            );
          })
          .closed
          .whenComplete(() {
            Provider.of<EditingSongModel>(context, listen: false)
                .closeKeyboard();
          });
    }

    Widget getChordListWidgets(context, List<String> strings, int listIndex,
        List<String> separationList, List<String> rhythmList) {
      List<Widget> separationText = [];
      List<Widget> lyrics = [];
      List<Widget> list = [];
      if (listIndex == 0) {
        separationText.add(
            separationTextStyle(context, " ${separationList[listIndex]} "));
        list.add(rhythmTextStyle(rhythmList[listIndex]));
        list.add(insertionContainer(context, "double"));
      } else {
        if (separationList[listIndex] != separationList[listIndex - 1]) {
          separationText.add(
              separationTextStyle(context, " ${separationList[listIndex]} "));
        } else {
          separationText.add(separationTextStyle(context, ""));
        }

        if (rhythmList[listIndex] != rhythmList[listIndex - 1]) {
          list.add(rhythmTextStyle(rhythmList[listIndex]));
          list.add(insertionContainer(context, "double"));
        } else {
          list.add(const Padding(
            padding: const EdgeInsets.only(left: 16.0),
          ));

          if (separationList[listIndex] != separationList[listIndex - 1]) {
            list.add(insertionContainer(context, "double"));
          } else
            list.add(insertionContainer(context));
        }
      }

      lyrics.add(Flexible(
          child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 48.0),
              child: TextFormField(
                key: _globalLyricFormList[listIndex],
                controller:
                    Provider.of<EditingSongModel>(context, listen: false)
                        .lyricControllerList[listIndex],
                showCursor: true,
                maxLines: null,
                onTap: () {
                  if (Provider.of<EditingSongModel>(context, listen: false)
                      .keyboardIsOpening) {
                    Provider.of<EditingSongModel>(context, listen: false)
                        .closeKeyboard();
                    Navigator.of(context).pop();
                  }
                  Provider.of<EditingSongModel>(context, listen: false)
                      .openNormalKeyboard();
                  Provider.of<EditingSongModel>(context, listen: false)
                      .scrollToTappedForm(listIndex: listIndex, mode: "lyrics");
                },
                onChanged: (text) {
                  Provider.of<EditingSongModel>(context, listen: false)
                      .editLyricsList(text, listIndex);
                },
              ))));

      for (var i = 0; i < strings.length; i++) {
        list.add(Flexible(
            child: TextField(
          key: i == 0 ? _globalChordFormList[listIndex] : null,
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
                .changeTextController(listIndex, i);
            Provider.of<EditingSongModel>(context, listen: false)
                .scrollToTappedForm(listIndex: listIndex, mode: "chord");
          },
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: -1,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFeatures: [
                FontFeature.enable('subs'),
              ]),
          controller: Provider.of<EditingSongModel>(context, listen: false)
              .chordControllerList[listIndex][i],
          onChanged: (text) {
            Provider.of<EditingSongModel>(context, listen: false)
                .editChordList(text, listIndex, i);
          },
        )));

        if (listIndex ==
                Provider.of<EditingSongModel>(context, listen: false)
                        .chordList
                        .length -
                    1 &&
            i == strings.length - 1) {
          list.add(insertionContainer(context, "last"));
        } else {
          list.add(insertionContainer(context));
        }
      }
      list.add(IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text("編集"),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: const ListTile(
                        // ignore: missing_required_param
                        leading: const IconButton(
                          icon: const Icon(Icons.delete),
                        ),
                        title: const Text('この行を削除する'),
                      ),
                      onPressed: () {
                        Provider.of<EditingSongModel>(context, listen: false)
                            .deleteOneLine(listIndex);
                        _setTextFieldComponents();
                        WidgetsBinding.instance
                            .addPostFrameCallback((cb) => _setEachOffsetList());
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: const ListTile(
                        // ignore: missing_required_param
                        leading: IconButton(
                          icon: const Icon(Icons.control_point),
                        ),
                        title: const Text('この行を複製して追加'),
                      ),
                      onPressed: () {
                        Provider.of<EditingSongModel>(context, listen: false)
                            .duplicateList(listIndex);
                        _setTextFieldComponents();
                        WidgetsBinding.instance
                            .addPostFrameCallback((cb) => _setEachOffsetList());
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text("戻る"),
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
          "chord") {
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

    void submitChordList(String docId) {
      String uid = Provider.of<AuthModel>(context, listen: false).user.uid;
      FirebaseFirestore.instance.collection("Songs").doc(docId).update({
        "codeList": formatChordList(
            Provider.of<EditingSongModel>(context, listen: false).chordList),
        "separation": Provider.of<EditingSongModel>(context, listen: false)
            .separationList,
        "rhythmList":
            Provider.of<EditingSongModel>(context, listen: false).rhythmList,
        "lyricsList":
            Provider.of<EditingSongModel>(context, listen: false).lyricsList,
        "updatedAt": DateTime.now(),
        "uid": uid,
        "type": "edit",
      });
      Provider.of<MetronomeModel>(context, listen: false).setMaxTickList(-1);
      Provider.of<MetronomeModel>(context, listen: false).textFormOffsetList =
          -1;
      Navigator.of(context).pop("edited");
    }

    void showDisplayTypeDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Center(child: const Text("編集方法の選択")),
              children: <Widget>[
                // コンテンツ領域
                SimpleDialogOption(
                  onPressed: () => {
                    Navigator.pop(context),
                    Provider.of<EditingSongModel>(context, listen: false)
                        .setDisplayType("both")
                  },
                  child: CheckboxListTile(
                    title: const Text("コードと歌詞"),
                    value: Provider.of<EditingSongModel>(context, listen: false)
                            .displayType ==
                        "both",
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                    onChanged: (e) => {
                      Navigator.pop(context),
                      Provider.of<EditingSongModel>(context, listen: false)
                          .setDisplayType("both"),
                      WidgetsBinding.instance
                          .addPostFrameCallback((cb) => _setEachOffsetList()),
                    },
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => {
                    Navigator.pop(context),
                    Provider.of<EditingSongModel>(context, listen: false)
                        .setDisplayType("chord")
                  },
                  child: CheckboxListTile(
                    title: const Text("コードのみ"),
                    value: Provider.of<EditingSongModel>(context, listen: false)
                            .displayType ==
                        "chord",
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                    onChanged: (e) => {
                      Navigator.pop(context),
                      Provider.of<EditingSongModel>(context, listen: false)
                          .setDisplayType("chord"),
                      WidgetsBinding.instance
                          .addPostFrameCallback((cb) => _setEachOffsetList()),
                    },
                  ),
                ),

                SimpleDialogOption(
                  onPressed: () => {
                    Navigator.pop(context),
                    Provider.of<EditingSongModel>(context, listen: false)
                        .setDisplayType("lyrics")
                  },
                  child: CheckboxListTile(
                    title: const Text("歌詞のみ"),
                    value: Provider.of<EditingSongModel>(context, listen: false)
                            .displayType ==
                        "lyrics",
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                    onChanged: (e) => {
                      Navigator.pop(context),
                      Provider.of<EditingSongModel>(context, listen: false)
                          .setDisplayType("lyrics"),
                      WidgetsBinding.instance
                          .addPostFrameCallback((cb) => _setEachOffsetList()),
                    },
                  ),
                ),
              ],
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (Provider.of<EditingSongModel>(context, listen: false)
                  .keyboardIsOpening) {
                Provider.of<EditingSongModel>(context, listen: false)
                    .closeKeyboard();
                Navigator.of(context).pop();
              }
              if (Provider.of<EditingSongModel>(context, listen: false)
                  .normalKeyboardIsOpen) {
                Provider.of<EditingSongModel>(context, listen: false)
                    .closeNormalKeyboard();
                FocusScope.of(context).unfocus();
              }
              Navigator.of(context).pop();
            }),
        title: const Text("編集ページ"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.view_headline),
              onPressed: () {
                showDisplayTypeDialog();
              }),
          TextButton(
            child: const Text("完了", style: TextStyle(fontSize: 18)),
            onPressed: () {
              if (Provider.of<EditingSongModel>(context, listen: false)
                  .normalKeyboardIsOpen) {
                FocusScope.of(context).unfocus();
                Provider.of<EditingSongModel>(context, listen: false)
                    .closeNormalKeyboard();
              }
              if (Provider.of<EditingSongModel>(context, listen: false)
                  .keyboardIsOpening) {
                Provider.of<EditingSongModel>(context, listen: false)
                    .closeKeyboard();
                Navigator.of(context).pop();
              }
              submitChordList(widget.docId);
            },
          ),
        ],
      ),
      body: Builder(
          builder: (context) => GestureDetector(
                onTap: () => {
                  if (Provider.of<EditingSongModel>(context, listen: false)
                      .normalKeyboardIsOpen)
                    {
                      Provider.of<EditingSongModel>(context, listen: false)
                          .closeNormalKeyboard()
                    },
                  if (Provider.of<EditingSongModel>(context, listen: false)
                      .keyboardIsOpening)
                    {
                      Provider.of<EditingSongModel>(context, listen: false)
                          .closeKeyboard(),
                      Navigator.of(context).pop(),
                    },
                  FocusScope.of(context).unfocus(),
                },
                child: Container(
                    child: Scrollbar(
                        controller: _scrollController,
                        isAlwaysShown: true,
                        thickness: 8.0,
                        hoverThickness: 12.0,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: bottomPadding(context),
                            child: Center(child: Consumer<EditingSongModel>(
                                builder: (_, model, __) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  for (int idx = 0;
                                      idx < model.chordList.length;
                                      idx++)
                                    getChordListWidgets(
                                        context,
                                        model.chordList[idx],
                                        idx,
                                        model.separationList,
                                        model.rhythmList),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<String>(
                                                  value:
                                                      model.selectedSeparation,
                                                  elevation: 16,
                                                  onChanged: (String newValue) {
                                                    model.setSelectedSeparation(
                                                        newValue);
                                                  },
                                                  items: <String>[
                                                    "Intro",
                                                    "A",
                                                    "B",
                                                    "C",
                                                    "D",
                                                    "間奏",
                                                    "サビ",
                                                    "Outro",
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<String>(
                                                  value: model.selectedRhythm,
                                                  elevation: 16,
                                                  onChanged: (String newValue) {
                                                    model.setSelectedRhythm(
                                                        newValue);
                                                  },
                                                  items: const <String>[
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: ButtonTheme(
                                                alignedDropdown: true,
                                                child: DropdownButton<int>(
                                                  value:
                                                      model.selectedBeatCount,
                                                  elevation: 16,
                                                  onChanged: (int newValue) {
                                                    model.setSelectedBeatCount(
                                                        newValue);
                                                  },
                                                  items: const <int>[
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
                                      ]),
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24.0),
                                      child: ElevatedButton(
                                        child: const Text('追加'),
                                        onPressed: () async {
                                          model.addEmptyList();
                                          _setTextFieldComponents();
                                          await Future.delayed(
                                              Duration(milliseconds: 200));
                                          model.scrollToEnd();
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (cb) => _setEachOffsetList());
                                        },
                                      ))
                                ],
                              );
                            })),
                          ),
                        ))),
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
