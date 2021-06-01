import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/metronome_model.dart';
import 'bpm_setting.dart';
import 'volume_setting.dart';

Container detailBottomBar(BuildContext context, MetronomeModel model) {
  final double bottomIconSIze = 36;

  return Container(
      color: Theme.of(context).primaryColor,
      width: MediaQuery.of(context).size.width,
      height: 100,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          flex: 1,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: CircleBorder(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("BPM", style: TextStyle(color: Colors.white)),
                Text(
                  model.tempoCount.toString(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            onPressed: () {
              print("Pressed: BPM");
              showModalBottomSheet<void>(
                useRootNavigator: false,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                context: context,
                builder: (context) => Navigator(
                    onGenerateRoute: (context) => MaterialPageRoute<BpmSetting>(
                          builder: (context) => BpmSetting(),
                        )),
              ).then((_) => model.resetBpmTapCount());
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: !model.isPlaying
              ? IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.play_arrow_rounded),
                  iconSize: bottomIconSIze,
                  onPressed: () {
                    model.switchPlayStatus();
                    model.metronomeLoad();
                    print("Pressed: Play");
                  },
                )
              : IconButton(
                  color: Colors.white,
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
            color: Colors.white,
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
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: VolumeSetting(),
              ),
            ],
            offset: Offset(0, -180),
          ),
        ),
      ]));
}
