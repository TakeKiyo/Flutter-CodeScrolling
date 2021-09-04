import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:my_app/models/theme_model.dart';
import 'package:my_app/pages/songs_list.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
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
  String udid;
  MyApp(String s) {
    this.udid = s;
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MetronomeModel>(
            create: (_) => MetronomeModel(),
          ),
          ChangeNotifierProvider<AuthModel>(
            create: (_) => AuthModel(udid),
          ),
          ChangeNotifierProvider<EditingSongModel>(
            create: (_) => EditingSongModel(),
          ),
          ChangeNotifierProvider<ThemeModel>(
            create: (_) => ThemeModel(),
          ),
        ],
        child: Consumer<ThemeModel>(builder: (context, theme, _) {
          return MaterialApp(
            title: 'Code Scrolling',
            theme: theme.currentTheme,
            darkTheme: theme.themeIndex == 0 ? ThemeData.dark() : null,
            home: SongsList(),
          );
        }));
  }
}
