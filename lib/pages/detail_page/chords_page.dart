import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import './style/display_text_style.dart';
import 'detail_edit_page.dart';

class ChordsPage extends StatefulWidget {
  ChordsPage(
      {this.chordList,
      this.bpm,
      this.title,
      this.docId,
      this.artist,
      this.separationList,
      this.rhythmList,
      this.lyricsList});
  final List<String> chordList;
  final int bpm;
  final String title;
  final String docId;
  final String artist;
  final List<String> separationList;
  final List<String> rhythmList;
  final List<String> lyricsList;

  @override
  _ChordsPageState createState() => _ChordsPageState();
}

class _ChordsPageState extends State<ChordsPage> {
  ScrollController _scrollController;
  final List<GlobalKey> _globalTextFormList = [];

  double _getLocaleAndSize(int listIndex) {
    RenderBox box =
        _globalTextFormList[listIndex].currentContext.findRenderObject();
    return box.localToGlobal(Offset.zero).dy;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Provider.of<MetronomeModel>(context, listen: false).setMaxTickList(-1);
    Provider.of<MetronomeModel>(context, listen: false).scrollController =
        _scrollController;
    Provider.of<MetronomeModel>(context, listen: false).textFormOffsetList = -1;
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MetronomeModel>(context, listen: false).deviceHeight =
        MediaQuery.of(context).size.height;

    List<List<String>> chordListState = [];
    for (int i = 0; i < widget.chordList.length; i++) {
      List<String> oneLineChord = widget.chordList[i].split(",");
      List<String> tmp = [];
      for (int j = 0; j < oneLineChord.length; j++) {
        tmp.add(oneLineChord[j]);
      }
      chordListState.add(tmp);
    }

    List<Widget> displayedWidget() {
      List<Widget> displayedList = [];

      displayedList.add(Padding(
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: Text(
              "${widget.title} / ${widget.artist}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )));

      displayedList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: Provider.of<EditingSongModel>(context).lyricsDisplayed,
            onChanged: (bool e) {
              Provider.of<MetronomeModel>(context, listen: false)
                  .textFormOffsetList = -1;
              Provider.of<EditingSongModel>(context, listen: false)
                  .handleCheckbox(e);
            },
          ),
          const Text("歌詞も表示する")
        ],
      ));

      for (int listIndex = 0; listIndex < chordListState.length; listIndex++) {
        final List<Widget> list = [];
        if (widget.separationList.length != 0) {
          if (listIndex == 0) {
            displayedList.add(separationTextStyle(
                context, " ${widget.separationList[listIndex]} "));
            if (Provider.of<EditingSongModel>(context, listen: false)
                .lyricsDisplayed) {
              displayedList.add(Text(widget.lyricsList[listIndex]));
            }
            list.add(rhythmTextStyle(widget.rhythmList[listIndex]));
            list.add(insertionContainer(context, "double"));
          } else {
            if (widget.separationList[listIndex] !=
                widget.separationList[listIndex - 1]) {
              displayedList.add(separationTextStyle(
                  context, " ${widget.separationList[listIndex]} "));
            } else {
              displayedList.add(separationTextStyle(context, ""));
            }

            if (Provider.of<EditingSongModel>(context, listen: false)
                .lyricsDisplayed) {
              displayedList.add(Text(widget.lyricsList[listIndex]));
            }

            if (widget.rhythmList[listIndex] !=
                widget.rhythmList[listIndex - 1]) {
              list.add(rhythmTextStyle(widget.rhythmList[listIndex]));
              list.add(insertionContainer(context, "double"));
            } else {
              list.add(const Padding(
                padding: const EdgeInsets.only(left: 16.0),
              ));
              if (widget.separationList[listIndex] !=
                  widget.separationList[listIndex - 1]) {
                list.add(insertionContainer(context, "double"));
              } else
                list.add(insertionContainer(context));
            }
          }
        }

        if (listIndex == 0)
          Provider.of<MetronomeModel>(context, listen: false).ticksPerRowList =
              widget.rhythmList;

        if (_globalTextFormList.length < chordListState.length) {
          _globalTextFormList.add(GlobalKey<FormState>());
        }

        if (Provider.of<MetronomeModel>(context, listen: false)
                .textFormOffsetList
                .length <
            chordListState.length) {
          Provider.of<MetronomeModel>(context, listen: false)
              .setMaxTickList(chordListState[listIndex].length, listIndex);

          ///列ごとビルドされ、その時にビルドされたTextFormの位置dyをMetronomeModelに渡す
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<MetronomeModel>(context, listen: false)
                .textFormOffsetList = _getLocaleAndSize(listIndex);
          });
        }

        int eachBeatCount(int index) {
          return Provider.of<MetronomeModel>(context, listen: false)
              .ticksPerRowList[index];
        }

        for (var i = 0; i < chordListState[listIndex].length; i++) {
          int addedRowBeatCount = 0;
          for (var j = 0; j < listIndex; j++) {
            addedRowBeatCount += eachBeatCount(j) * chordListState[j].length;
          }

          final int maxRowBeatCount = addedRowBeatCount +
              eachBeatCount(listIndex) * chordListState[listIndex].length;

          int addedColumnBeatCount = 0;
          for (var j = 0; j < i; j++) {
            addedColumnBeatCount += eachBeatCount(listIndex);
          }

          final int maxColumnBeatCount =
              addedColumnBeatCount + eachBeatCount(listIndex);

          list.add(Expanded(
            child: Selector<MetronomeModel, int>(
              selector: (context, model) => model.metronomeContainerStatus,

              ///shouldRebuildでnewStatus=カウントした値が色の変わるべき条件だったらリビルドする
              ///カウントインをプレイ中はリビルドしない
              shouldRebuild: (_, notifiedMetronomeContainerStatus) =>
                  notifiedMetronomeContainerStatus == -1 ||
                  (!Provider.of<MetronomeModel>(context, listen: false)
                          .isCountInPlaying &&
                      notifiedMetronomeContainerStatus >=
                          addedRowBeatCount + addedColumnBeatCount &&
                      notifiedMetronomeContainerStatus <=
                          addedRowBeatCount + maxColumnBeatCount &&
                      notifiedMetronomeContainerStatus <= maxRowBeatCount),
              builder: (context, containerStatus, child) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (!Provider.of<MetronomeModel>(context,
                                      listen: false)
                                  .isCountInPlaying &&
                              Provider.of<MetronomeModel>(context,
                                          listen: false)
                                      .metronomeContainerStatus >=
                                  addedRowBeatCount + addedColumnBeatCount &&
                              Provider.of<MetronomeModel>(context,
                                          listen: false)
                                      .metronomeContainerStatus <
                                  addedRowBeatCount + maxColumnBeatCount &&
                              Provider.of<MetronomeModel>(context,
                                          listen: false)
                                      .metronomeContainerStatus <
                                  maxRowBeatCount)
                          ? Colors.orange.withOpacity(0.5)
                          : Colors.transparent,
                    ),
                    child: child),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  chordListState[listIndex][i],
                  key: i == 0 ? _globalTextFormList[listIndex] : null,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: -1,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFeatures: [
                        FontFeature.enable('subs'),
                      ]),
                ),
              ),
            ),
          ));

          if (listIndex == chordListState.length - 1 &&
              i == chordListState[listIndex].length - 1) {
            list.add(insertionContainer(context, "last"));
          } else
            list.add(insertionContainer(context));
        }
        displayedList.add(Row(children: list));
      }
      return displayedList;
    }

    if (widget.chordList.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
              onPressed: () {
                Provider.of<MetronomeModel>(context, listen: false).tempoCount =
                    widget.bpm;
                Provider.of<MetronomeModel>(context, listen: false).forceStop();
                Provider.of<EditingSongModel>(context, listen: false)
                    .chordList = [];
                Provider.of<EditingSongModel>(context, listen: false)
                    .rhythmList = [];
                Provider.of<EditingSongModel>(context, listen: false)
                    .separationList = [];
                Provider.of<EditingSongModel>(context, listen: false)
                    .lyricsList = widget.lyricsList;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return DetailEditPage(
                        bpm: widget.bpm,
                        title: widget.title,
                        docId: widget.docId,
                      );
                    },
                  ),
                );
              },
              child: const Text("コードを編集する")),
          const Text("まだコードは追加されていません")
        ],
      ));
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
            child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Scrollbar(
                controller: _scrollController,
                isAlwaysShown: false,
                thickness: 8.0,
                hoverThickness: 12.0,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ListView(
                      padding: const EdgeInsets.all(20.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: displayedWidget(),
                    ))),
            Positioned(
              bottom: 5,
              child: Selector<MetronomeModel, bool>(
                  selector: (context, model) => model.hasScrolledDuringPlaying,
                  shouldRebuild: (exScrollStatus, notifiedScrollStatus) =>
                      exScrollStatus != notifiedScrollStatus,
                  builder: (context, hasScrolledDuringPlaying, child) =>
                      Visibility(
                        visible: hasScrolledDuringPlaying &&
                            Provider.of<MetronomeModel>(context, listen: false)
                                .isPlaying,
                        child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.9),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: TextButton(
                              child: const Text("スクロールを\n再開する",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )))),
                              onPressed: () {
                                Provider.of<MetronomeModel>(context,
                                        listen: false)
                                    .enableScroll();
                                Provider.of<MetronomeModel>(context,
                                        listen: false)
                                    .scrollToNowPlaying();
                              },
                            )),
                      )),
            )
          ],
        )),
        onPanDown: (_) {
          if (Provider.of<MetronomeModel>(context, listen: false).isPlaying &&
              _scrollController.offset !=
                  _scrollController.initialScrollOffset &&
              _scrollController.offset !=
                  _scrollController.position.maxScrollExtent)
            Provider.of<MetronomeModel>(context, listen: false).unableScroll();
        },
      );
    }
  }
}
