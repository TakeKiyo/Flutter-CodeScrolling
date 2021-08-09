import 'package:flutter/material.dart';

class ScrollablePage extends StatefulWidget {
  ScrollablePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScrollPageState createState() => _ScrollPageState();
}

class _ScrollPageState extends State<ScrollablePage> {
  int _currentIndex = 0; // currentIndexにデフォルト値を与えないとコンパイルエラー

  bool _showBackToTopButton = false;

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

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
                child: Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: true,
                    thickness: 8.0,
                    hoverThickness: 12.0,
                    child: ListView(
                        padding: EdgeInsets.all(36.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          TextButton(
                              onPressed: () {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  curve: Curves.linear,
                                  duration: const Duration(milliseconds: 1000),
                                );
                              },
                              child: Text("スクロール")),
                          Container(
                            color: Colors.red,
                            child: Text(
                              "ジョナサン・ジョースター",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.green,
                            child: Text(
                              "ジョセフ・ジョースター",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Text(
                              "空条承太郎",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                _scrollController.animateTo(
                                  0.0,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 1000),
                                );
                              },
                              child: Text("TOPに戻る")),
                        ])))));
  }
}
