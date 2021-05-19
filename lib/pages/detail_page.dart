import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';
import '../models/metronome_model.dart';
import 'bpm_setting.dart';
import 'volume_setting.dart';

class DetailPage extends StatelessWidget {
  final double bottomIconSIze = 36;

  @override
  Widget build(BuildContext context) {
    final User _user = context.select((AuthModel _auth) => _auth.user);
    String message;
    if (_user != null) {
      message = _user.email;
    } else {
      message = 'ログインしてない';
    }
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                model.forceStop();
              }),
          title: Text('Code Scrolling'),
          actions: <Widget>[
            PopupMenuButton(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              icon: Icon(Icons.person),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {},
                    child: Text(message),
                  ),
                ),
                PopupMenuItem(
                  child: InkWell(
                      onTap: () {
                        context.read<AuthModel>().logout();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.black87),
                          Text("ログアウト"),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ログイン',
              ),
              Text(message),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: CircleBorder(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BPM"),
                        Text(
                          Provider.of<MetronomeModel>(context)
                              .tempoCount
                              .toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    onPressed: () {
                      print("Pressed: BPM");
                      showDialog<void>(
                        context: context,
                        builder: (_) {
                          return BpmSetting();
                        },
                      ).then((_) => model.resetBpmTapCount());
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: !model.isPlaying
                      ? IconButton(
                          icon: Icon(Icons.play_arrow_rounded),
                          iconSize: bottomIconSIze,
                          onPressed: () {
                            model.switchPlayStatus();
                            model.metronomeLoad();
                            print("Pressed: Play");
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.pause_rounded),
                          iconSize: bottomIconSIze,
                          onPressed: () {
                            model.metronomeClear();
                            model.switchPlayStatus();
                            print("Pressed: Pause");
                          },
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.stop_rounded),
                    iconSize: bottomIconSIze,
                    onPressed: () {
                      model.forceStop();
                      print("Pressed: Stop");
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: PopupMenuButton(
                    icon: VolumeIcon(),
                    iconSize: bottomIconSIze,
                    elevation: 1,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: VolumeSetting(),
                      ),
                    ],
                    offset: Offset(0, -180),
                  ),
                ),
              ])),
        ],
      );
    });
  }
}
