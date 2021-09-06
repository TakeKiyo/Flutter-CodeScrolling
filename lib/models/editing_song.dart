import 'package:flutter/material.dart';

class EditingSongModel extends ChangeNotifier {
  String _displayType = "both";
  get displayType => _displayType;
  void setDisplayType(String selectedType) {
    _displayType = selectedType;
    notifyListeners();
  }

  List<List<String>> _codeList = [];
  get codeList => _codeList;

  int _selectedBeatCount = 4;
  get selectedBeatCount => _selectedBeatCount;

  void setSelectedBeatCount(int selectedCount) {
    _selectedBeatCount = selectedCount;
    notifyListeners();
  }

  void addEmptyList() {
    var emptyList = List.filled(_selectedBeatCount, "");
    _codeList.add(emptyList);
    _separationList.add(_selectedSeparation);
    _rhythmList.add(_selectedRhythm);
    _lyricsList.add("");
    notifyListeners();
  }

  void duplicateList(int listIndex) {
    List<String> duplicatedList = [];
    for (int i = 0; i < _codeList[listIndex].length; i++) {
      duplicatedList.add(_codeList[listIndex][i]);
    }
    _codeList.add(duplicatedList);
    String duplicatedSeparation = _separationList[listIndex];
    _separationList.add(duplicatedSeparation);
    String duplicatedRhythm = _rhythmList[listIndex];
    _rhythmList.add(duplicatedRhythm);
    _lyricsList.add("");
    notifyListeners();
  }

  String _selectedSeparation = "Intro";
  get selectedSeparation => _selectedSeparation;

  List<String> _separationList = [];
  get separationList => _separationList;
  void setSelectedSeparation(String selectedSeparation) {
    _selectedSeparation = selectedSeparation;
    notifyListeners();
  }

  set separationList(List<String> fetchedSeparationList) {
    _separationList = [];
    for (int i = 0; i < fetchedSeparationList.length; i++) {
      _separationList.add(fetchedSeparationList[i]);
    }
    if (fetchedSeparationList.length > 0) {
      _selectedSeparation = fetchedSeparationList.last;
    } else {
      _selectedSeparation = "Intro";
    }
  }

  String _selectedRhythm = "4/4";
  get selectedRhythm => _selectedRhythm;

  List<String> _rhythmList = [];
  get rhythmList => _rhythmList;
  void setSelectedRhythm(String selectedRhythm) {
    _selectedRhythm = selectedRhythm;
    notifyListeners();
  }

  set rhythmList(List<String> fetchedRhythmList) {
    _rhythmList = [];
    for (int i = 0; i < fetchedRhythmList.length; i++) {
      _rhythmList.add(fetchedRhythmList[i]);
    }
    if (fetchedRhythmList.length > 0) {
      _selectedRhythm = fetchedRhythmList.last;
    } else {
      _selectedRhythm = "4/4";
    }
  }

  List<String> _lyricsList = [];
  get lyricsList => _lyricsList;
  set lyricsList(List<String> fetchedLyricsList) {
    _lyricsList = [];
    for (int i = 0; i < fetchedLyricsList.length; i++) {
      _lyricsList.add(fetchedLyricsList[i]);
    }
  }

  void editLyricsList(String lyrics, int listIndex) {
    _lyricsList[listIndex] = lyrics;
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
    _separationList.removeAt(listIndex);
    _rhythmList.removeAt((listIndex));
    _lyricsList.removeAt(listIndex);
    notifyListeners();
  }

  void editCodeList(String code, int barIdx, int timeIdx) {
    _codeList[barIdx][timeIdx] = code;
  }

  int _scrollSpeed = 30000;
  get scrollSpeed => _scrollSpeed;
  void setScrollSpeed(double newSpeed) {
    _scrollSpeed = ((61 - newSpeed) * 1000).toInt();
    notifyListeners();
  }

  ///detailEditPageビルド時に代入
  ScrollController editScrollController;

  List<double> _codeFormOffsetList = [];
  List<double> _lyricFormOffsetList = [];
  get codeFormOffsetList => _codeFormOffsetList;
  get lyricFormOffsetList => _lyricFormOffsetList;

  double deviceHeight = 0;

  set codeFormOffsetList(double yOffset) {
    double tmp = yOffset;
    if (yOffset == -1) {
      //scrollablePage呼び出し時に初期化
      _codeFormOffsetList = [];
    } else {
      _codeFormOffsetList.add(tmp + editScrollController.offset);
    }
  }

  set lyricFormOffsetList(double yOffset) {
    double tmp = yOffset;
    if (yOffset == -1) {
      //scrollablePage呼び出し時に初期化
      _lyricFormOffsetList = [];
    } else {
      _lyricFormOffsetList.add(tmp + editScrollController.offset);
    }
  }

  void scrollToTappedForm({int listIndex, String mode}) {
    if (editScrollController.hasClients) {
      switch (mode) {
        case "code":
          editScrollController.animateTo(
            (_codeFormOffsetList[listIndex] > deviceHeight / 2)
                ? _codeFormOffsetList[listIndex] - (deviceHeight / 2)
                : 0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
          break;
        case "lyrics":
          editScrollController.animateTo(
            (_lyricFormOffsetList[listIndex] > deviceHeight / 2)
                ? _lyricFormOffsetList[listIndex] - (deviceHeight / 2)
                : 0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
          break;
      }
    }
  }

  void scrollToTop() {
    if (editScrollController.hasClients) {
      editScrollController.jumpTo(
        editScrollController.position.minScrollExtent,
      );
    }
  }

  void scrollToEnd() {
    if (editScrollController.hasClients) {
      editScrollController.animateTo(
        editScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  List<TextEditingController> _lyricControllerList = [];
  get lyricControllerList => _lyricControllerList;
  set lyricControllerList(TextEditingController controller) {
    if (controller == null) {
      _lyricControllerList = [];
    } else {
      _lyricControllerList.add(controller);
    }
  }

  List<List<TextEditingController>> _codeControllerList = [];
  get codeControllerList => _codeControllerList;
  set codeControllerList(List<TextEditingController> controllerList) {
    if (controllerList == null) {
      _codeControllerList = [];
    } else {
      _codeControllerList.add(controllerList);
    }
  }

  ///detail_edit_pageでTextFieldをTapする度に対応したTextEditingControllerを代入する
  TextEditingController currentCodeController;
  int controlBarIdx = 0;
  int controlTimeIdx = 0;

  bool _keyboardIsOpening = false;
  get keyboardIsOpening => _keyboardIsOpening;
  double _keyboardBottomSpace = 0;
  get keyboardBottomSpace => _keyboardBottomSpace;
  bool _normalKeyboardIsOpen = false;
  get normalKeyboardIsOpen => _normalKeyboardIsOpen;

  void openKeyboard() {
    _keyboardIsOpening = true;
    _keyboardBottomSpace = 300;
    notifyListeners();
  }

  void openNormalKeyboard() {
    _normalKeyboardIsOpen = true;
    _keyboardBottomSpace = 350;
    notifyListeners();
  }

  void closeNormalKeyboard() {
    _normalKeyboardIsOpen = false;
    _keyboardBottomSpace = 0;
    notifyListeners();
  }

  void closeKeyboard() {
    _keyboardIsOpening = false;
    _keyboardBottomSpace = 0;
    notifyListeners();
  }

  void changeTextController(TextEditingController controller) {
    this.currentCodeController = controller;
    notifyListeners();
  }

  void changeSelectionToLeft() {
    final textSelection = currentCodeController.selection;
    if (textSelection.start > 0) {
      currentCodeController.selection = TextSelection(
          baseOffset: textSelection.start - 1,
          extentOffset: textSelection.start - 1);
    }
  }

  void changeSelectionToRight() {
    final text = currentCodeController.text;
    final textSelection = currentCodeController.selection;
    if (text.length > textSelection.end) {
      currentCodeController.selection = TextSelection(
          baseOffset: textSelection.end + 1,
          extentOffset: textSelection.end + 1);
    }
  }

  void insertText(String myText) {
    final text = currentCodeController.text;
    final textSelection = currentCodeController.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    currentCodeController.text = newText;
    currentCodeController.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
    editCodeList(newText, controlBarIdx, controlTimeIdx);
    notifyListeners();
  }

  void backspace() {
    final text = currentCodeController.text;
    final textSelection = currentCodeController.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      currentCodeController.text = newText;
      currentCodeController.selection = textSelection.copyWith(
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
    currentCodeController.text = newText;
    currentCodeController.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
    editCodeList(newText, controlBarIdx, controlTimeIdx);
    notifyListeners();
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }
}
