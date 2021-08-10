import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song_model.dart';
import 'package:my_app/models/metronome_bpm_model.dart';
import 'package:provider/provider.dart';

import 'detail_edit_page.dart';

class ScrollablePage extends StatefulWidget {
  ScrollablePage(this.codeList, this.bpm, this.title, this.docId);
  final List<String> codeList;
  final int bpm;
  final String title;
  final String docId;

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
            Provider.of<MetronomeBpmModel>(context, listen: false).tempoCount =
                widget.bpm;
            Provider.of<EditingSongModel>(context, listen: false).codeList =
                widget.codeList;
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
        List<Widget> list = [];
        for (var i = 0; i < codeListState[listIndex].length; i++) {
          list.add(Flexible(
              child: TextField(
            enabled: false,
            textAlign: TextAlign.center,
            controller:
                TextEditingController(text: codeListState[listIndex][i]),
          )));
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
                Provider.of<MetronomeBpmModel>(context, listen: false)
                    .tempoCount = widget.bpm;
                Provider.of<EditingSongModel>(context, listen: false).codeList =
                    [];
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
