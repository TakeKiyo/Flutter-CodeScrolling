import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyboardDemo extends StatefulWidget {
  @override
  _KeyboardDemoState createState() => _KeyboardDemoState();
}

class _KeyboardDemoState extends State<KeyboardDemo> {
  TextEditingController _controller = TextEditingController();
  bool _readOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 50),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            style: TextStyle(fontSize: 24),
            autofocus: true,
            showCursor: true,
            readOnly: _readOnly,
          ),
          IconButton(
            icon: Icon(Icons.keyboard),
            onPressed: () {
              setState(() {
                _readOnly = !_readOnly;
              });
            },
          ),
          Spacer(),
          CustomKeyboard(
            onTextInput: (myText) {
              _insertText(myText);
              print(myText);
            },
            onBackspace: () {
              _backspace();
            },
          ),
        ],
      ),
    );
  }

  void _insertText(String myText) {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    print(textSelection.start);
    print(textSelection.end);
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _controller.text = newText;
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

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
          insertPadding,
          buildRowOne(),
          insertPadding,
          buildRowTwo(),
          insertPadding,
          buildRowThree(),
          insertPadding,
          buildRowFour(),
          Padding(padding: EdgeInsets.only(bottom: safeAreaHeight))
        ],
      ),
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
      "Φ",
      "sus",
      "add",
      "alt"
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

  Expanded buildRowFour() {
    final rowOneElem = [
      "C",
      "D",
      "E",
      "F",
      "G",
      "A",
      "B",
      "A",
      "♭",
      "♯",
      "M",
      "m"
    ];

    return Expanded(
      child: Row(
          children: rowOneElem
              .map((elm) => TextKey(text: elm, onTextInput: _textInputHandler))
              .toList()),
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              onTextInput?.call(text);
            },
            child: Container(
              child: Center(child: Text(text)),
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
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.blue.shade300,
          child: InkWell(
            onTap: () {
              onBackspace?.call();
            },
            child: Container(
              child: Center(
                child: Icon(Icons.backspace),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
