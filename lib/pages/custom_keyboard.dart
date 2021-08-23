import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:provider/provider.dart';

class CustomKeyboard extends StatelessWidget {
  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final Padding insertPadding = Padding(padding: const EdgeInsets.all(3.0));

  CustomKeyboard({
    Key key,
    this.onTextInput,
    this.onBackspace,
  }) : super(key: key);

  void _textInputHandler(String text) => onTextInput?.call(text);

  void _backspaceHandler() => onBackspace?.call();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
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
          insertPadding,
          buildRowFour(),
          Padding(padding: EdgeInsets.only(bottom: 70))
        ],
      ),
    );
  }

  Container buildRowSetting(BuildContext context) {
    return Container(
      height: 50,
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
            onPressed: () {
              Provider.of<EditingSongModel>(context, listen: false)
                  .changeSelectionToLeft();
            }),
        IconButton(
            icon: Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey),
            onPressed: () {
              Provider.of<EditingSongModel>(context, listen: false)
                  .changeSelectionToRight();
            }),
      ]),
    );
  }

  Expanded buildRowOne() {
    const rowTwoElem = ["1", "2", "3", "4", "5", "6", "7", "9", "♭", "♯"];

    return Expanded(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowTwoElem
              .map((elm) => TextKey(
                    text: elm,
                    onTextInput: _textInputHandler,
                  ))
              .toList()),
    );
  }

  Expanded buildRowTwo() {
    const rowOneElem = ["C", "D", "E", "F", "G", "A", "B", "M", "m"];

    return Expanded(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowOneElem
              .map((elm) => TextKey(
                    text: elm,
                    onTextInput: _textInputHandler,
                  ))
              .toList()),
    );
  }

  Expanded buildRowThree() {
    const rowThreeElem = ["dim", "sus", "add", "alt", "/", "N.C."];

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpacerWidget(),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rowThreeElem
                  .map((elm) => TextKey(
                        text: elm,
                        onTextInput: _textInputHandler,
                      ))
                  .toList()),
          BackspaceKey(
            onBackspace: _backspaceHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowFour() {
    return Expanded(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FunctionKey(
          label: "abc",
          keyWidth: 4,
        ),
        TextKey(
          text: " ",
          label: "space",
          keyWidth: 2,
          onTextInput: _textInputHandler,
        ),
        FunctionKey(
          label: "Done",
          keyWidth: 4,
        ),
      ]),
    );
  }
}

class TextKey extends StatelessWidget {
  final String text;
  final String label;
  final ValueSetter<String> onTextInput;
  final int keyWidth;

  const TextKey({
    Key key,
    @required this.text,
    this.label = "",
    this.onTextInput,
    this.keyWidth = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / keyWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
        child: Material(
          color: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              onTextInput?.call(text);
            },
            child: Container(
              child: Center(
                child: (label == "")
                    ? Text(
                        text,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    : Text(
                        label,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: Colors.grey[700],
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

class SpacerWidget extends StatelessWidget {
  final double spaceWidth;

  const SpacerWidget({Key key, this.spaceWidth = 6}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / spaceWidth,
      child: Padding(padding: const EdgeInsets.all(2.0)),
    );
  }
}

class FunctionKey extends StatelessWidget {
  final String label;
  final int keyWidth;

  const FunctionKey({
    Key key,
    this.label = "",
    this.keyWidth = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / keyWidth,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          color: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              print("Tapped");
            },
            child: Container(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
