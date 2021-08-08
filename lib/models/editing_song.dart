import 'package:flutter/material.dart';

class EditingSongModel extends ChangeNotifier {
  List<List<String>> _codeList = [];
  get codeList => _codeList;

  void addEmptyList() {
    _codeList.add(["", "", "", ""]);
    notifyListeners();
  }

  // 曲の詳細画面から、編集画面に遷移するときに呼ばれる
  set codeList(List<String> fetchedCodeList) {
    _codeList = [];
    for (int i = 0; i < fetchedCodeList.length; i++) {
      List<String> oneLineCode = fetchedCodeList[i].split(",");
      List<String> tmp = [];
      for (int j = 0; j < oneLineCode.length; j++) {
        tmp.add(oneLineCode[j]);
      }
      _codeList.add(tmp);
    }
  }

  void deleteOneLine(int listIndex) {
    _codeList.removeAt(listIndex);
    notifyListeners();
  }

  void editCodeList(String code, int barIdx, int timeIdx) {
    _codeList[barIdx][timeIdx] = code;
    notifyListeners();
  }

  TextEditingController _controller = TextEditingController();
  get controller => _controller;

  set controller(String inputText) {
    _controller = TextEditingController(text: inputText);
  }

  int controlBarIdx;
  int controlTimeIdx;

  void insertText(String myText) {
    final text = _controller.text;
    final textSelection = _controller.selection;
    print(textSelection.start);
    print(textSelection.end);
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    print(text);
    print(textSelection.start);
    print(textSelection.end);
    final myTextLength = myText.length;
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
    editCodeList(newText, controlBarIdx, controlTimeIdx);
    notifyListeners();
  }

  void backspace() {
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
    notifyListeners();
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
