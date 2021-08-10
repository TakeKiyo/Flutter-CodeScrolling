import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/editing_song_model.dart';
import 'package:my_app/models/metronome_bpm_model.dart';
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
          ChangeNotifierProvider<MetronomeBpmModel>(
            create: (_) => MetronomeBpmModel(),
          ),
          ChangeNotifierProvider<AuthModel>(
            create: (_) => AuthModel(udid),
          ),
          ChangeNotifierProvider<EditingSongModel>(
            create: (_) => EditingSongModel(),
          ),
        ],
        child: MaterialApp(
          title: 'Code Scrolling',
          theme: ThemeData(primarySwatch: Colors.blueGrey),
          home: SongsList(),
        ));
  }
}
