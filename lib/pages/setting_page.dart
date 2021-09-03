import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/theme_model.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  final List<DropdownMenuItem<int>> _themeList = [
    DropdownMenuItem(
      value: 0,
      child: Text("自動"),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text("明るい"),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text("ダーク"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('設定'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 3, child: Text("アプリテーマ：　")),
                Flexible(
                  flex: 1,
                  child: ButtonTheme(
                    minWidth: 20,
                    alignedDropdown: true,
                    child: Consumer<ThemeModel>(builder: (_, theme, __) {
                      return DropdownButton<int>(
                        isExpanded: true,
                        value: theme.themeIndex,
                        elevation: 16,
                        onChanged: (int newValue) {
                          theme.themeIndex = newValue;
                        },
                        items: _themeList,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
