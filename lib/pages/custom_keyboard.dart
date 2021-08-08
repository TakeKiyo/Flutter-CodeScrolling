import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:provider/provider.dart';

class CustomKeyboard extends StatelessWidget {
  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final double safeAreaHeight;
  final Padding insertPadding = Padding(padding: const EdgeInsets.all(2.0));

  CustomKeyboard(
      {Key key, this.onTextInput, this.onBackspace, this.safeAreaHeight})
      : super(key: key);

  void _textInputHandler(String text) => onTextInput?.call(text);

  void _backspaceHandler() => onBackspace?.call();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.grey[800],
      child: Column(
        children: [
          buildRowSetting(context),
          insertPadding,
          buildRowOne(),
          insertPadding,
          buildRowTwo(),
          insertPadding,
          buildRowThree(),
          Padding(padding: EdgeInsets.only(bottom: safeAreaHeight))
        ],
      ),
    );
  }

  Container buildRowSetting(BuildContext context) {
    return Container(
      height: 40,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        IconButton(
            icon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey),
            onPressed: () {
              Provider.of<EditingSongModel>(context, listen: false)
                  .closeKeyboard();
              Navigator.of(context).pop();
            }),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 2.0),
                child: TextField(
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        fillColor: Colors.grey[600],
                        filled: true),
                    textAlign: TextAlign.center,
                    controller:
                        Provider.of<EditingSongModel>(context).controller,
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) {
                      Provider.of<EditingSongModel>(context, listen: false)
                          .controller
                          .text = text;
                    }))),
        IconButton(
            icon: Icon(Icons.keyboard_arrow_left_outlined, color: Colors.grey),
            onPressed: () {}),
        IconButton(
            icon: Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey),
            onPressed: () {}),
      ]),
    );
  }

  Expanded buildRowOne() {
    final rowOneElem = ["C", "D", "E", "F", "G", "A", "B", "♭", "♯", "M", "m"];

    return Expanded(
      child: Row(
          children: rowOneElem
              .map((elm) => TextKey(text: elm, onTextInput: _textInputHandler))
              .toList()),
    );
  }

  Expanded buildRowTwo() {
    final rowTwoElem = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "9",
      "dim",
      "sus",
      "add",
      "alt",
    ];

    return Expanded(
      child: Row(
          children: rowTwoElem
              .map((elm) => TextKey(text: elm, onTextInput: _textInputHandler))
              .toList()),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: ' ',
            flex: 4,
            onTextInput: _textInputHandler,
          ),
          BackspaceKey(
            onBackspace: _backspaceHandler,
          ),
        ],
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  const TextKey({Key key, @required this.text, this.onTextInput, this.flex = 1})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: Colors.grey[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              onTextInput?.call(text);
            },
            child: Container(
              child: Center(
                  child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  final VoidCallback onBackspace;
  final int flex;

  const BackspaceKey({Key key, this.onBackspace, this.flex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              onBackspace?.call();
            },
            child: Container(
              child: Center(
                child: Icon(Icons.backspace_outlined, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
