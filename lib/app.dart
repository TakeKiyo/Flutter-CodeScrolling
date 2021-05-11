import 'package:flutter/material.dart';
import 'package:my_app/models/ScrollModel.dart';
import './pages/my_home_page.dart';
import 'package:provider/provider.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollModel>(
        create: (_) => ScrollModel(),
        child: MaterialApp(
          title: 'Code Scrolling',
          theme: ThemeData(primarySwatch: Colors.blueGrey),
          home: MyHomePage(),
        ));
  }
}
