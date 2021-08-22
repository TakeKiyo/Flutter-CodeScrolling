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
  // コントローラ
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      displayedList.add(TextButton(
          onPressed: () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 10000),
            );
          },
          child: Text("スクロール")));
      for (int listIndex = 0; listIndex < codeListState.length; listIndex++) {
        List<Widget> list = [];
        if (widget.separationList.length != 0) {
          if (listIndex == 0) {
            displayedList.add(Text(widget.separationList[listIndex],
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                )));
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

        for (var i = 0; i < codeListState[listIndex].length; i++) {
          ///TODO 4 * codeListState[~].length => その行の拍数の合計に置き換え
          int addedRowBeatCount = 0;
          for (var j = 0; j < listIndex; j++) {
            addedRowBeatCount += 4 * codeListState[j].length;
          }

          final int maxRowBeatCount =
              addedRowBeatCount + 4 * codeListState[listIndex].length;

          ///TODO 4 => そのTextFormのもつ拍数に置き換え
          int addedColumnBeatCount = 0;
          for (var j = 0; j < i; j++) {
            addedColumnBeatCount += 4;
          }

          final int maxColumnBeatCount = addedColumnBeatCount + 4;

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

      displayedList.add(TextButton(
          onPressed: () {
            _scrollController.jumpTo(
              0.0,
            );
          },
          child: Text("上まで戻る")));

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
      return Container(
          child: Scrollbar(
              // controller: _scrollController,
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
                  ))));
    }
  }
}
