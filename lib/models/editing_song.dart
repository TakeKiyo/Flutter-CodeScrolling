import 'package:flutter/material.dart';

class EditingSongModel extends ChangeNotifier {
  List<List<String>> _codeList = [];
  get codeList => _codeList;

  int _selectedBeatCount = 4;
  get selectedBeatCount => _selectedBeatCount;

  void setSelectedBeatCount(int selectedCount) {
    _selectedBeatCount = selectedCount;
    notifyListeners();
  }

  void addEmptyList() {
    var emptyList = new List.filled(_selectedBeatCount, "");
    _codeList.add(emptyList);
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

  ///detail_edit_pageでTextFieldをTapする度に対応したTextEditingControllerを代入する
  TextEditingController controller;
  int controlBarIdx;
  int controlTimeIdx;
  bool _keyboardIsOpening = false;
  get keyboardIsOpening => _keyboardIsOpening;

  void openKeyboard() {
    _keyboardIsOpening = true;
    notifyListeners();
  }

  void closeKeyboard() {
    _keyboardIsOpening = false;
    notifyListeners();
  }

  void changeTextController(TextEditingController controller) {
    this.controller = controller;
    notifyListeners();
  }

  void changeSelectionToLeft() {
    final textSelection = controller.selection;
    if (textSelection.start > 0) {
      controller.selection = TextSelection(
          baseOffset: textSelection.start - 1,
          extentOffset: textSelection.start - 1);
      notifyListeners();
    }
  }

  void changeSelectionToRight() {
    final text = controller.text;
    final textSelection = controller.selection;
    if (text.length > textSelection.end) {
      controller.selection = TextSelection(
          baseOffset: textSelection.end + 1,
          extentOffset: textSelection.end + 1);
      notifyListeners();
    }
  }

  void insertText(String myText) {
    final text = controller.text;
    final textSelection = controller.selection;
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
    controller.text = newText;
    controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
    editCodeList(newText, controlBarIdx, controlTimeIdx);
    notifyListeners();
  }

  void backspace() {
    final text = controller.text;
    final textSelection = controller.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      controller.text = newText;
      controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      editCodeList(newText, controlBarIdx, controlTimeIdx);
      notifyListeners();
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return null;
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
    controller.text = newText;
    controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
    editCodeList(newText, controlBarIdx, controlTimeIdx);
    notifyListeners();
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
