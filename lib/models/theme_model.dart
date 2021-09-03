import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
  );
  get currentTheme => _currentTheme;

  //  themeIndex = 0:自動, 1:ライトモード, 2:ダークモード
  int _themeIndex = 0;
  get themeIndex => _themeIndex;
  set themeIndex(int fetchedIndex) {
    switch (fetchedIndex) {
      case 0:
        _themeIndex = fetchedIndex;
        _currentTheme = ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.white,
        );
        break;

      case 1:
        _themeIndex = fetchedIndex;
        _currentTheme = ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.white,
        );
        break;

      case 2:
        _themeIndex = fetchedIndex;
        _currentTheme = ThemeData.dark();
        break;
    }
    notifyListeners();
  }
}
