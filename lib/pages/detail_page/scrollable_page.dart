import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import 'detail_edit_page.dart';

class ScrollablePage extends StatefulWidget {
  ScrollablePage(
      this.codeList, this.bpm, this.title, this.docId, this.separationList);
  final List<String> codeList;
  final int bpm;
  final String title;
  final String docId;
  final List<String> separationList;

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
        if (widget.separationList.length != 0) {
          if (listIndex == 0) {
            displayedList.add(Text(widget.separationList[listIndex],
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                )));
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
          }
        }

        List<Widget> list = [];
        list.add(Padding(
          padding: const EdgeInsets.only(left: 16.0),
        ));
        for (var i = 0; i < codeListState[listIndex].length; i++) {
          int minRowBeatCount = 0;

          //minRowBeatCount = listIndex-1　番目までの拍数の足し合わせ
          for (var j = 0; j < listIndex; j++) {
            minRowBeatCount += 4 * codeListState[j].length;
          }

          //maxRowBeatCount = listIndex+1番目の行の拍数の合計
          int maxRowBeatCount =
              minRowBeatCount + 4 * codeListState[listIndex].length;

          int minColumnBeatCount = 0;
          //minColumnBeatCount = CodeList[listIndex]のi-1番目までの拍数の足し合わせ
          for (var j = 0; j < i; j++) {
            minColumnBeatCount += 4;
          }

          //maxColumnBeatCount = minColumnBeatCount + i+1　番目の拍数
          int maxColumnBeatCount = minColumnBeatCount + 4;

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
                          minRowBeatCount + minColumnBeatCount &&
                      notifiedMetronomeContainerStatus <=
                          minRowBeatCount + maxColumnBeatCount &&
                      notifiedMetronomeContainerStatus <= maxRowBeatCount),
              builder: (context, containerStatus, child) => Container(
                  color: (!Provider.of<MetronomeModel>(context, listen: false)
                              .isCountInPlaying &&
                          Provider.of<MetronomeModel>(context, listen: false)
                                  .metronomeContainerStatus >=
                              minRowBeatCount + minColumnBeatCount &&
                          Provider.of<MetronomeModel>(context, listen: false)
                                  .metronomeContainerStatus <
                              minRowBeatCount + maxColumnBeatCount &&
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
                    .separationList = [];
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
              isAlwaysShown: true,
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
