import 'package:flutter/material.dart';

class EditingSongModel extends ChangeNotifier {
  String _displayType = "both";
  get displayType => _displayType;
  void setDisplayType(String selectedType) {
    _displayType = selectedType;
    notifyListeners();
  }

  bool _lyricsDisplayed = false;
  get lyricsDisplayed => _lyricsDisplayed;
  void handleCheckbox(bool e) {
    _lyricsDisplayed = e;
    notifyListeners();
  }

  List<List<String>> _chordList = [];
  get chordList => _chordList;

  int _selectedBeatCount = 4;
  get selectedBeatCount => _selectedBeatCount;

  void setSelectedBeatCount(int selectedCount) {
    _selectedBeatCount = selectedCount;
    notifyListeners();
  }

  void addEmptyList() {
    var emptyList = List.filled(_selectedBeatCount, "");
    _chordList.add(emptyList);
    _separationList.add(_selectedSeparation);
    _rhythmList.add(_selectedRhythm);
    _lyricsList.add("");
    notifyListeners();
  }

  void duplicateList(int listIndex) {
    List<String> duplicatedList = [];
    for (int i = 0; i < _chordList[listIndex].length; i++) {
      duplicatedList.add(_chordList[listIndex][i]);
    }
    _chordList.add(duplicatedList);
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
  set chordList(List<String> fetchedChordList) {
    _chordList = [];
    for (int i = 0; i < fetchedChordList.length; i++) {
      List<String> oneLineChord = fetchedChordList[i].split(",");
      List<String> tmp = [];
      for (int j = 0; j < oneLineChord.length; j++) {
        tmp.add(oneLineChord[j]);
      }
      _chordList.add(tmp);
    }
  }

  void deleteOneLine(int listIndex) {
    _chordList.removeAt(listIndex);
    _separationList.removeAt(listIndex);
    _rhythmList.removeAt((listIndex));
    _lyricsList.removeAt(listIndex);
    notifyListeners();
  }

  void editChordList(String chord, int barIdx, int timeIdx) {
    _chordList[barIdx][timeIdx] = chord;
  }

  int _scrollSpeed = 30000;
  get scrollSpeed => _scrollSpeed;
  void setScrollSpeed(double newSpeed) {
    _scrollSpeed = ((61 - newSpeed) * 1000).toInt();
    notifyListeners();
  }

  ///detailEditPageビルド時に代入
  ScrollController editScrollController;

  List<double> _chordFormOffsetList = [];
  List<double> _lyricFormOffsetList = [];
  get chordFormOffsetList => _chordFormOffsetList;
  get lyricFormOffsetList => _lyricFormOffsetList;

  double deviceHeight = 0;

  set chordFormOffsetList(double yOffset) {
    double tmp = yOffset;
    if (yOffset == -1) {
      //scrollablePage呼び出し時に初期化
      _chordFormOffsetList = [];
    } else {
      _chordFormOffsetList.add(tmp + editScrollController.offset);
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
        case "chord":
          editScrollController.animateTo(
            (_chordFormOffsetList[listIndex] > deviceHeight / 2)
                ? _chordFormOffsetList[listIndex] - (deviceHeight / 2)
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

  List<List<TextEditingController>> _chordControllerList = [];
  get chordControllerList => _chordControllerList;
  set chordControllerList(List<TextEditingController> controllerList) {
    if (controllerList == null) {
      _chordControllerList = [];
    } else {
      _chordControllerList.add(controllerList);
    }
  }

  ///detail_edit_pageでTextFieldをTapする度に対応した座標を代入する
  int _controlBarIdx = 0;
  get listIndex => _controlBarIdx;
  int _controlTimeIdx = 0;
  get idx => _controlTimeIdx;
  TextEditingController _currentController;
  get currentController => _currentController;

  bool _keyboardIsOpening = false;
  get keyboardIsOpening => _keyboardIsOpening;
  double _keyboardBottomSpace = 0;
  get keyboardBottomSpace => _keyboardBottomSpace;
  bool _normalKeyboardIsOpen = false;
  get normalKeyboardIsOpen => _normalKeyboardIsOpen;

  void openKeyboard() {
    _keyboardIsOpening = true;
    _keyboardBottomSpace = 350;
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

  void changeTextController(int listIndex, int idx) {
    _controlBarIdx = listIndex;
    _controlTimeIdx = idx;
    _currentController = _chordControllerList[listIndex][idx];
    notifyListeners();
  }

  void changeSelectionToLeft() {
    final textSelection =
        _chordControllerList[_controlBarIdx][_controlTimeIdx].selection;
    if (textSelection.start > 0) {
      _chordControllerList[_controlBarIdx][_controlTimeIdx].selection =
          TextSelection(
              baseOffset: textSelection.start - 1,
              extentOffset: textSelection.start - 1);
    }
  }

  void changeSelectionToRight() {
    final text = _chordControllerList[_controlBarIdx][_controlTimeIdx].text;
    final textSelection =
        _chordControllerList[_controlBarIdx][_controlTimeIdx].selection;
    if (text.length > textSelection.end) {
      _chordControllerList[_controlBarIdx][_controlTimeIdx].selection =
          TextSelection(
              baseOffset: textSelection.end + 1,
              extentOffset: textSelection.end + 1);
    }
  }

  void insertText(String myText) {
    final text = _chordControllerList[_controlBarIdx][_controlTimeIdx].text;
    final textSelection =
        _chordControllerList[_controlBarIdx][_controlTimeIdx].selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _chordControllerList[_controlBarIdx][_controlTimeIdx].text = newText;
    _chordControllerList[_controlBarIdx][_controlTimeIdx].selection =
        textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
    editChordList(newText, _controlBarIdx, _controlTimeIdx);
    notifyListeners();
  }

  void backspace() {
    final text = _chordControllerList[_controlBarIdx][_controlTimeIdx].text;
    final textSelection =
        _chordControllerList[_controlBarIdx][_controlTimeIdx].selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _chordControllerList[_controlBarIdx][_controlTimeIdx].text = newText;
      _chordControllerList[_controlBarIdx][_controlTimeIdx].selection =
          textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      editChordList(newText, _controlBarIdx, _controlTimeIdx);
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
    _chordControllerList[_controlBarIdx][_controlTimeIdx].text = newText;
    _chordControllerList[_controlBarIdx][_controlTimeIdx].selection =
        textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
    editChordList(newText, _controlBarIdx, _controlTimeIdx);
    notifyListeners();
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }
}
