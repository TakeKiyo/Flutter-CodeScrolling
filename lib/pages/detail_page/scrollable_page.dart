import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import 'detail_edit_page.dart';

class ScrollablePage extends StatefulWidget {
  ScrollablePage(this.codeList, this.bpm, this.title, this.docId,
      this.separationList, this.rhythmList, this.lyricsList);
  final List<String> codeList;
  final int bpm;
  final String title;
  final String docId;
  final List<String> separationList;
  final List<String> rhythmList;
  final List<String> lyricsList;

  @override
  _ScrollPageState createState() => _ScrollPageState();
}

class _ScrollPageState extends State<ScrollablePage> {
  bool _lyricsDisplayed = false;
  void _handleCheckbox(bool e) {
    setState(() {
      _lyricsDisplayed = e;
      Provider.of<MetronomeModel>(context, listen: false).textFormOffsetList =
          -1;
    });
  }

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

    List<List<String>> codeListState = [];
    for (int i = 0; i < widget.codeList.length; i++) {
      List<String> oneLineCode = widget.codeList[i].split(",");
      List<String> tmp = [];
      for (int j = 0; j < oneLineCode.length; j++) {
        tmp.add(oneLineCode[j]);
      }
      codeListState.add(tmp);
    }

    List<Widget> displayedWidget() {
      List<Widget> displayedList = [];
      displayedList.add(TextButton(
          onPressed: () {
            Provider.of<MetronomeModel>(context, listen: false).tempoCount =
                widget.bpm;
            Provider.of<EditingSongModel>(context, listen: false).codeList =
                widget.codeList;
            Provider.of<EditingSongModel>(context, listen: false)
                .separationList = widget.separationList;
            Provider.of<EditingSongModel>(context, listen: false).rhythmList =
                widget.rhythmList;
            Provider.of<EditingSongModel>(context, listen: false).lyricsList =
                widget.lyricsList;
            if (_lyricsDisplayed) {
              Provider.of<EditingSongModel>(context, listen: false)
                  .setDisplayType("both");
            } else {
              Provider.of<EditingSongModel>(context, listen: false)
                  .setDisplayType("code");
            }
            Navigator.of(context).push(
              MaterialPageRoute(
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
          child: Text("コードを編集する")));
      bool noCode = true;
      for (int i = 0; i < codeListState.length; i++) {
        for (int j = 0; j < codeListState[i].length; j++) {
          if (codeListState[i][j] != "") {
            noCode = false;
          }
        }
      }

      if (noCode) {
        displayedList.add(Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text('コードは追加されていません。'),
            ])));
        return displayedList;
      }
      displayedList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            activeColor: Colors.blue,
            value: _lyricsDisplayed,
            onChanged: _handleCheckbox,
          ),
          Text("歌詞も表示する")
        ],
      ));
      for (int listIndex = 0; listIndex < codeListState.length; listIndex++) {
        List<Widget> list = [];
        if (widget.separationList.length != 0) {
          if (listIndex == 0) {
            displayedList.add(Text(widget.separationList[listIndex],
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                )));
            if (_lyricsDisplayed) {
              displayedList.add(Text(widget.lyricsList[listIndex]));
            }
            list.add(Text(widget.rhythmList[listIndex]));
          } else {
            if (widget.separationList[listIndex] !=
                widget.separationList[listIndex - 1]) {
              displayedList.add(Text(widget.separationList[listIndex],
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black,
                  )));
            } else {
              displayedList.add(Text(""));
            }

            if (_lyricsDisplayed) {
              displayedList.add(Text(widget.lyricsList[listIndex]));
            }

            if (widget.rhythmList[listIndex] !=
                widget.rhythmList[listIndex - 1]) {
              list.add(Text(widget.rhythmList[listIndex]));
            } else {
              list.add(Padding(
                padding: const EdgeInsets.only(left: 24.0),
              ));
            }
          }
        }

        _globalTextFormList.add(GlobalKey<FormState>());

        ///列ごとビルドされ、その時にビルドされたTextFormの位置dyをMetronomeModelに渡す
        WidgetsBinding.instance.addPostFrameCallback((cb) {
          Provider.of<MetronomeModel>(context, listen: false)
              .textFormOffsetList = _getLocaleAndSize(listIndex);
        });

        Provider.of<MetronomeModel>(context, listen: false).ticksPerRowList =
            widget.rhythmList;

        Provider.of<MetronomeModel>(context, listen: false)
            .setMaxTickList(codeListState[listIndex].length, listIndex);

        int eachBeatCount(int index) {
          return Provider.of<MetronomeModel>(context, listen: false)
              .ticksPerRowList[index];
        }

        for (var i = 0; i < codeListState[listIndex].length; i++) {
          int addedRowBeatCount = 0;
          for (var j = 0; j < listIndex; j++) {
            addedRowBeatCount += eachBeatCount(j) * codeListState[j].length;
          }

          final int maxRowBeatCount = addedRowBeatCount +
              eachBeatCount(listIndex) * codeListState[listIndex].length;

          int addedColumnBeatCount = 0;
          for (var j = 0; j < i; j++) {
            addedColumnBeatCount += eachBeatCount(listIndex);
          }

          final int maxColumnBeatCount =
              addedColumnBeatCount + eachBeatCount(listIndex);

          list.add(Flexible(
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
              builder: (context, containerStatus, child) => Container(
                  color: (!Provider.of<MetronomeModel>(context, listen: false)
                              .isCountInPlaying &&
                          Provider.of<MetronomeModel>(context, listen: false)
                                  .metronomeContainerStatus >=
                              addedRowBeatCount + addedColumnBeatCount &&
                          Provider.of<MetronomeModel>(context, listen: false)
                                  .metronomeContainerStatus <
                              addedRowBeatCount + maxColumnBeatCount &&
                          Provider.of<MetronomeModel>(context, listen: false)
                                  .metronomeContainerStatus <
                              maxRowBeatCount)
                      ? Colors.amberAccent
                      : Colors.transparent,
                  child: child),
              child: TextField(
                key: i == 0 ? _globalTextFormList[listIndex] : null,
                enabled: false,
                textAlign: TextAlign.center,
                controller:
                    TextEditingController(text: codeListState[listIndex][i]),
              ),
            ),
          ));
          list.add(Text("|"));
        }
        displayedList.add(Row(children: list));
      }

      return displayedList;
    }

    if (widget.codeList.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
              onPressed: () {
                Provider.of<MetronomeModel>(context, listen: false).tempoCount =
                    widget.bpm;
                Provider.of<EditingSongModel>(context, listen: false).codeList =
                    [];
                Provider.of<EditingSongModel>(context, listen: false)
                    .rhythmList = [];
                Provider.of<EditingSongModel>(context, listen: false)
                    .separationList = [];
                Provider.of<EditingSongModel>(context, listen: false)
                    .lyricsList = widget.lyricsList;
                Navigator.of(context).push(
                  MaterialPageRoute(
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
              child: Text("コードを編集する")),
          Text("まだコードは追加されていません")
        ],
      ));
    } else {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
              child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: false,
                    thickness: 8.0,
                    hoverThickness: 12.0,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        child: ListView(
                          padding: EdgeInsets.all(36.0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: displayedWidget(),
                        ))),
              ),
              Positioned(
                bottom: 5,
                child: Selector<MetronomeModel, bool>(
                    selector: (context, model) =>
                        model.hasScrolledDuringPlaying,
                    shouldRebuild: (exScrollStatus, notifiedScrollStatus) =>
                        exScrollStatus != notifiedScrollStatus,
                    builder: (context, hasScrolledDuringPlaying, child) =>
                        hasScrolledDuringPlaying &&
                                Provider.of<MetronomeModel>(context,
                                        listen: false)
                                    .isPlaying
                            ? Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.9),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: TextButton(
                                  child: Text("スクロールを\n再開する",
                                      style: TextStyle(
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
                                ))
                            : Container()),
              )
            ],
          )),
          onTapDown: (_) {
            Provider.of<MetronomeModel>(context, listen: false).unableScroll();
          });
    }
  }
}
