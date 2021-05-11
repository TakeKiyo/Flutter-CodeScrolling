import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';
import '../models/scroll_model.dart';
import 'bpm_setting.dart';

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
    return Consumer<ScrollModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Code Scrolling'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.remove),
                  tooltip: 'Decrement',
                  onPressed: model.decrement),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'BPM:',
                  ),
                  CounterText(),
                ],
              ),
              IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'Increment',
                  onPressed: model.increment),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ログイン',
                  ),
                  Text(message),
                ],
              ),
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
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BPM:"),
                        CounterText(),
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
                  child: !model.isPlaying
                      ? IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: bottomIconSIze,
                          onPressed: () {
                            model.switchPlayStatus();
                            print("Pressed: Play");
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.pause),
                          iconSize: bottomIconSIze,
                          onPressed: () {
                            model.switchPlayStatus();
                            print("Pressed: Pause");
                          },
                        ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.stop),
                    iconSize: bottomIconSIze,
                    onPressed: () {
                      model.forceStop();
                      print("Pressed: Stop");
                    },
                  ),
                ),
              ])),
        ],
      );
    });
  }
}
