import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );

  ThemeData _currentTheme = ThemeData(primarySwatch: Colors.white);
  get currentTheme => _currentTheme;

  //  themeIndex = 0:自動, 1:ライトモード, 2:ダークモード
  int _themeIndex = 0;
  get themeIndex => _themeIndex;
  set themeIndex(int fetchedIndex) {
    switch (fetchedIndex) {
      case 0:
        _themeIndex = fetchedIndex;
        _currentTheme = ThemeData(primarySwatch: Colors.white);
        break;

      case 1:
        _themeIndex = fetchedIndex;
        _currentTheme = ThemeData(primarySwatch: Colors.white);
        break;

      case 2:
        _themeIndex = fetchedIndex;
        _currentTheme = ThemeData.dark();
        break;
    }
    notifyListeners();
  }
}
