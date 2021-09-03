import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:my_app/models/theme_model.dart';
import 'package:my_app/pages/songs_list.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
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
