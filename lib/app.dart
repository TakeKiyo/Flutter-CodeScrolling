import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/editing_song.dart';
import 'package:my_app/models/metronome_model.dart';
import 'package:my_app/models/theme_model.dart';
import 'package:my_app/pages/my_home_page.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MetronomeModel>(
            create: (_) => MetronomeModel(),
          ),
          ChangeNotifierProvider<AuthModel>(
            create: (_) => AuthModel(),
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
            debugShowCheckedModeBanner: false,
            title: 'Bandout',
            theme: theme.currentTheme,
            darkTheme: theme.themeIndex == 0 ? theme.darkTheme : null,
            home: HomePage(),
          );
        }));
  }
}
