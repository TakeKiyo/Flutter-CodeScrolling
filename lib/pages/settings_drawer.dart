import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            ListTile(
              title: Text("曲情報", style: TextStyle(color: Colors.white)),
              onTap: () {
                print("Information");
                //TODO ボタンを押したら情報変更画面
              },
            ),
            ListTile(
                title:
                    Text("メトロノーム音の変更", style: TextStyle(color: Colors.white)),
                onTap: () {
                  print("Metronome Sound");
                  //TODO
                }),
          ],
        ),
      ),
    );
  }
}
