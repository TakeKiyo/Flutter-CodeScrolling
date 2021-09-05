import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData();
  get currentTheme => _currentTheme;

  ThemeModel() {
    _currentTheme = _lightTheme;
  }

  final ThemeData _lightTheme = ThemeData(
    primaryColorLight: Colors.blue[500],
    primaryColor: Colors.blue[800],
    primaryColorDark: Colors.blue[900],
    canvasColor: Colors.grey[200],
    colorScheme: ColorScheme(
        //primary => TextSelection, TextButton, Sliderなど広範に利用される
        //secondary => accentColor(Floating Action Button)など。
        primary: Colors.blue[800],
        primaryVariant: Colors.blue[900],
        secondary: Colors.blue[800],
        secondaryVariant: Colors.blue[900],
        surface: Colors.white,
        background: Colors.white,
        error: Colors.red[600],
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light),
    appBarTheme: AppBarTheme(
        //default color = primaryColor
        color: Colors.grey[200],
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20.0),
        toolbarTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black)),
    //チェックボックスの色をprimaryColorに合わせる。default = primarySwatch
    toggleableActiveColor: Colors.blue[800],
  );

  //_lightTheme.copyWith() method doesn't work
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColorLight: Colors.blue[500],
    primaryColor: Colors.blue[800],
    primaryColorDark: Colors.blue[900],
    colorScheme: ColorScheme(
        primary: Colors.blue[800],
        primaryVariant: Colors.blue[900],
        secondary: Colors.blue[800],
        secondaryVariant: Colors.blue[900],
        surface: Colors.white,
        background: Colors.white,
        error: Colors.red[600],
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
        brightness: Brightness.dark),
    appBarTheme: AppBarTheme(
        color: Colors.grey[850],
        brightness: Brightness.dark,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        toolbarTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white)),
    toggleableActiveColor: Colors.blue[800],
    //TextFieldのunFocus/Focus時の色を指定。
    inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200])),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[800]))),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue[800],
      selectionColor: Colors.blue[800],
      selectionHandleColor: Colors.blue[800],
    ),
  );
  get darkTheme => _darkTheme;

  //  themeIndex = 0:自動, 1:ライトモード, 2:ダークモード
  int _themeIndex = 0;
  get themeIndex => _themeIndex;
  set themeIndex(int fetchedIndex) {
    switch (fetchedIndex) {
      case 0:
        _themeIndex = fetchedIndex;
        _currentTheme = _lightTheme;
        break;

      case 1:
        _themeIndex = fetchedIndex;
        _currentTheme = _lightTheme;
        break;

      case 2:
        _themeIndex = fetchedIndex;
        _currentTheme = _darkTheme;
        break;
    }
    notifyListeners();
  }
}
