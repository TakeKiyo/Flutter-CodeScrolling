import 'package:flutter/material.dart';
import 'package:my_app/models/auth_model.dart';
import 'package:my_app/models/scroll_model.dart';
import 'package:provider/provider.dart';

import './pages/my_home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ScrollModel>(
            create: (_) => ScrollModel(),
          ),
          ChangeNotifierProvider<AuthModel>(
            create: (_) => AuthModel(),
          )
        ],
        child: MaterialApp(
          title: 'Code Scrolling',
          theme: ThemeData(primarySwatch: Colors.blueGrey),
          home: MyHomePage(),
        ));
  }
}
