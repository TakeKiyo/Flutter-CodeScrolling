import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData();
  get currentTheme => _currentTheme;

  ThemeModel() {
    _currentTheme = _lightTheme;
  }

  final ThemeData _lightTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColorLight: Colors.blue[500],
      primaryColor: Colors.blue[800],
      primaryColorDark: Colors.blue[900],
      canvasColor: Colors.grey[200],
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
          brightness: Brightness.light),
      appBarTheme: AppBarTheme(
          color: Colors.grey[200],
          textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black, fontSize: 20.0)),
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black)),
      toggleableActiveColor: Colors.blue[800],
      primaryTextTheme: TextTheme(caption: TextStyle()));

  //_lightTheme.copyWith() method doesn't work
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
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
        textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white, fontSize: 20.0)),
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white)),
    toggleableActiveColor: Colors.blue[800],
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue[800])),
    ),
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
