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

  void editCodeList(String code, int barIdx, int timeIdx) {
    _codeList[barIdx][timeIdx] = code;
    notifyListeners();
  }
}
