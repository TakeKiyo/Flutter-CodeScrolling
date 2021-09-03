import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:provider/provider.dart';

import '../custom_keyboard.dart';
import 'detail_page.dart';

class DetailEditPage extends StatefulWidget {
  final int bpm;
  final String title;
  final String docId;

  DetailEditPage({this.bpm, this.title, this.docId});

  _DetailEditPageState createState() => _DetailEditPageState();
}

class _DetailEditPageState extends State<DetailEditPage> {
  ScrollController _scrollController;
  final List<GlobalKey> _globalLyricFormList = [];
  final List<GlobalKey> _globalCodeFormList = [];

  double _getLyricLocale(int listIndex) {
    RenderBox box =
        _globalLyricFormList[listIndex].currentContext.findRenderObject();
    return box.localToGlobal(Offset.zero).dy;
  }

  double _getCodeLocale(int listIndex) {
    RenderBox box =
        _globalCodeFormList[listIndex].currentContext.findRenderObject();
    return box.localToGlobal(Offset.zero).dy;
  }

  void _resetOffsetList() {
    Provider.of<EditingSongModel>(context, listen: false).codeFormOffsetList =
        -1;
    Provider.of<EditingSongModel>(context, listen: false).lyricFormOffsetList =
        -1;
  }

  void _setEachOffsetList() {
    print("set");
    _resetOffsetList();
    switch (Provider.of<EditingSongModel>(context, listen: false).displayType) {
      case "code":
        for (int listIndex = 0;
            listIndex <
                Provider.of<EditingSongModel>(context, listen: false)
                    .codeList
                    .length;
            listIndex++)
          Provider.of<EditingSongModel>(context, listen: false)
              .codeFormOffsetList = _getCodeLocale(listIndex);
        break;
      case "both":
        for (int listIndex = 0;
            listIndex <
                Provider.of<EditingSongModel>(context, listen: false)
                    .codeList
                    .length;
            listIndex++) {
          Provider.of<EditingSongModel>(context, listen: false)
              .codeFormOffsetList = _getCodeLocale(listIndex);
          Provider.of<EditingSongModel>(context, listen: false)
              .lyricFormOffsetList = _getLyricLocale(listIndex);
        }
        break;
      case "lyrics":
        for (int listIndex = 0;
            listIndex <
                Provider.of<EditingSongModel>(context, listen: false)
                    .codeList
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
    WidgetsBinding.instance.addPostFrameCallback((cb) => _setEachOffsetList());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    Provider.of<EditingSongModel>(context, listen: false).deviceHeight =
        MediaQuery.of(context).size.height;

    void _showCustomKeyboard(context) {
      Scaffold.of(context).showBottomSheet((BuildContext context) {
        return CustomKeyboard(
          onTextInput: (myText) {
            Provider.of<EditingSongModel>(context, listen: false)
                .insertText(myText);
          },
          onBackspace:
              Provider.of<EditingSongModel>(context, listen: false).backspace,
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

      _globalLyricFormList.add(GlobalKey<FormState>());
      _globalCodeFormList.add(GlobalKey<FormState>());

      final _lyricsController = TextEditingController(
          text: Provider.of<EditingSongModel>(context, listen: false)
              .lyricsList[listIndex]);
      _lyricsController.selection = TextSelection.fromPosition(
          TextPosition(offset: _lyricsController.text.length));
      lyrics.add(Flexible(
          child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 48.0),
              child: TextFormField(
                key: _globalLyricFormList[listIndex],
                controller: _lyricsController,
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
        final _controller = TextEditingController(text: strings[i]);
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
        list.add(Flexible(
            child: TextField(
          key: i == 0 ? _globalCodeFormList[listIndex] : null,
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
            Provider.of<EditingSongModel>(context, listen: false)
                .scrollToTappedForm(listIndex: listIndex, mode: "code");
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
      String udid = await FlutterUdid.udid;
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
        "udid": udid,
        "type": "edit",
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
              title: Center(child: Text("編集方法の選択")),
              children: <Widget>[
                // コンテンツ領域
                SimpleDialogOption(
                  onPressed: () => {
                    Navigator.pop(context),
                    Provider.of<EditingSongModel>(context, listen: false)
                        .setDisplayType("both")
                  },
                  child: CheckboxListTile(
                    title: Text("コードと歌詞"),
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
                  // child: Text("コードと歌詞を編集"),
                ),
                SimpleDialogOption(
                  onPressed: () => {
                    Navigator.pop(context),
                    Provider.of<EditingSongModel>(context, listen: false)
                        .setDisplayType("code")
                  },
                  child: CheckboxListTile(
                    title: Text("コードのみ"),
                    value: Provider.of<EditingSongModel>(context, listen: false)
                            .displayType ==
                        "code",
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                    onChanged: (e) => {
                      Navigator.pop(context),
                      Provider.of<EditingSongModel>(context, listen: false)
                          .setDisplayType("code"),
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
                    title: Text("歌詞のみ"),
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
            icon: Icon(Icons.close),
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
        title: Text("編集ページ"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.view_headline),
              onPressed: () {
                showDisplayTypeDialog();
              }),
          TextButton(
            child: Text("完了", style: TextStyle(fontSize: 18)),
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
              submitCodeList(widget.docId);
            },
          ),
        ],
      ),
      body: Builder(
          builder: (context) => GestureDetector(
                onTap: () => {
                  FocusScope.of(context).unfocus(),
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
                    }
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
                                      idx < model.codeList.length;
                                      idx++)
                                    getCodeListWidgets(
                                        context,
                                        model.codeList[idx],
                                        idx,
                                        model.separationList,
                                        model.rhythmList),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 24.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                child: ButtonTheme(
                                                    alignedDropdown: true,
                                                    child:
                                                        DropdownButton<String>(
                                                      value: model
                                                          .selectedSeparation,
                                                      elevation: 16,
                                                      onChanged:
                                                          (String newValue) {
                                                        model
                                                            .setSelectedSeparation(
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
                                                    child:
                                                        DropdownButton<String>(
                                                      value:
                                                          model.selectedRhythm,
                                                      elevation: 16,
                                                      onChanged:
                                                          (String newValue) {
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
                                                      value: model
                                                          .selectedBeatCount,
                                                      elevation: 16,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      onChanged:
                                                          (int newValue) {
                                                        model
                                                            .setSelectedBeatCount(
                                                                newValue);
                                                      },
                                                      items: <int>[
                                                        1,
                                                        2,
                                                        3,
                                                        4,
                                                        5,
                                                        6
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                                int>(
                                                            value: value,
                                                            child: Text(value
                                                                    .toString() +
                                                                '小節'));
                                                      }).toList(),
                                                    ))),
                                            ElevatedButton(
                                              child: const Text('追加',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.orange),
                                              onPressed: () async {
                                                model.addEmptyList();
                                                await Future.delayed(Duration(
                                                    milliseconds: 200));
                                                model.scrollToEnd();
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((cb) =>
                                                        _setEachOffsetList());
                                              },
                                            )
                                          ])),
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
