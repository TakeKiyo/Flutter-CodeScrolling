import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/metronome_model.dart';
import 'bpm_setting.dart';

class DetailPage extends StatelessWidget {
  final double bottomIconSIze = 36;

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                model.forceStop();
              }),
          title: Text('Code Scrolling'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'テキスト',
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
                  child: !model.isPlaying
                      ? IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: bottomIconSIze,
                          onPressed: () {
                            model.switchPlayStatus();
                            model.metronomeLoad();
                            print("Pressed: Play");
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.pause),
                          iconSize: bottomIconSIze,
                          onPressed: () {
                            model.switchPlayStatus();
                            model.metronomeClear();
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
