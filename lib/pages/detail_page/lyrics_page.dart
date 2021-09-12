import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:provider/provider.dart';

import './style/display_text_style.dart';
import 'detail_edit_page.dart';

class LyricsPage extends StatefulWidget {
  LyricsPage(
      {this.chordList,
      this.bpm,
      this.title,
      this.artist,
      this.docId,
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
  _ScrollLyricsPageState createState() => _ScrollLyricsPageState();
}

class _ScrollLyricsPageState extends State<LyricsPage> {
  bool _isScrolling;
  ScrollController _scrollController;

  double _scrollSpeed = 30.0;

  final String turtleIcon = 'assets/icons/turtle.svg';
  final String rabbitIcon = 'assets/icons/easter-bunny.svg';

  @override
  void initState() {
    super.initState();
    _isScrolling = false;
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => showToast());
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  void showToast() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey,
      content: const Text('画面をタップするとスクロールが始まります'),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyricsList.length == 0) {
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
              child: const Text("曲を編集する")),
          const Text("まだ歌詞は追加されていません")
        ],
      ));
    } else {
      List<List<String>> codeListState = [];
      for (int i = 0; i < widget.chordList.length; i++) {
        List<String> oneLineCode = widget.chordList[i].split(",");
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
              Provider.of<EditingSongModel>(context, listen: false).chordList =
                  widget.chordList;
              Provider.of<EditingSongModel>(context, listen: false)
                  .separationList = widget.separationList;
              Provider.of<EditingSongModel>(context, listen: false).rhythmList =
                  widget.rhythmList;
              Provider.of<EditingSongModel>(context, listen: false).lyricsList =
                  widget.lyricsList;
              Provider.of<EditingSongModel>(context, listen: false)
                  .setDisplayType("lyrics");
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
            child: const Text("曲を編集する")));
        bool noLyrics = true;
        for (int listIndex = 0;
            listIndex < widget.lyricsList.length;
            listIndex++) {
          if (widget.lyricsList[listIndex] != "") {
            noLyrics = false;
          }
        }
        if (noLyrics) {
          displayedList.add(Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                const Text('歌詞は追加されていません。'),
              ])));
          return displayedList;
        }
        for (int listIndex = 0;
            listIndex < widget.lyricsList.length;
            listIndex++) {
          if (widget.separationList.length != 0) {
            if (listIndex == 0) {
              displayedList.add(separationTextStyle(
                  context, " ${widget.separationList[listIndex]} "));
            } else {
              if (widget.separationList[listIndex] !=
                  widget.separationList[listIndex - 1]) {
                displayedList.add(separationTextStyle(
                    context, " ${widget.separationList[listIndex]} "));
              }
            }
            displayedList.add(Text(widget.lyricsList[listIndex],
                style: const TextStyle(
                  fontSize: 20,
                )));
          }
        }
        displayedList.add(Padding(padding: EdgeInsets.only(bottom: 20)));

        return displayedList;
      }

      return Stack(children: <Widget>[
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
                child: Scrollbar(
                    isAlwaysShown: false,
                    thickness: 8.0,
                    hoverThickness: 12.0,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        child: ListView(
                          padding: const EdgeInsets.all(36.0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: displayedWidget(),
                        )))),
            onTap: () {
              if (_isScrolling == true) {
                _scrollController.jumpTo(_scrollController.offset);
                setState(() {
                  _isScrolling = false;
                });
              } else {
                setState(() {
                  _isScrolling = true;
                });
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: Duration(
                      milliseconds:
                          Provider.of<EditingSongModel>(context, listen: false)
                              .scrollSpeed),
                );
              }
            }),
        Positioned(
            bottom: 30.0,
            left: 10.0,
            child: SvgPicture.asset(
              turtleIcon,
              color: Theme.of(context).iconTheme.color,
              semanticsLabel: 'turtle',
              width: 30.0,
            )),
        Positioned(
            bottom: 20.0,
            left: 25.0,
            right: 35.0,
            child: Slider(
              value: _scrollSpeed,
              min: 0.0,
              max: 60.0,
              divisions: 60,
              onChanged: (double value) {
                setState(() {
                  _scrollSpeed = value;
                });
                Provider.of<EditingSongModel>(context, listen: false)
                    .setScrollSpeed(_scrollSpeed);
              },
              onChangeEnd: (double value) {
                if (_isScrolling == true) {
                  _scrollController.jumpTo(_scrollController.offset);
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    curve: Curves.easeOut,
                    duration: Duration(
                        milliseconds: Provider.of<EditingSongModel>(context,
                                listen: false)
                            .scrollSpeed),
                  );
                }
              },
            )),
        Positioned(
            bottom: 32.0,
            right: 15.0,
            child: SvgPicture.asset(
              rabbitIcon,
              color: Theme.of(context).iconTheme.color,
              semanticsLabel: 'rabbit',
              width: 30.0,
            )),
      ]);
    }
  }
}
