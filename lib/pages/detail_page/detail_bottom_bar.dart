import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/metronome_model.dart';
import 'bpm_setting.dart';
import 'countin_dialog.dart';
import 'volume_setting.dart';

Container detailBottomBar(BuildContext context, MetronomeModel model) {
  final double bottomIconSIze = 36;
  final Color textColor = Colors.white;

  return Container(
      color: Theme.of(context).primaryColor,
      width: MediaQuery.of(context).size.width,
      height: 100,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 60,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: model.metronomeContainerColor,
                shape: CircleBorder(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("BPM", style: TextStyle(color: textColor)),
                  Text(
                    model.tempoCount.toString(),
                    style: TextStyle(fontSize: 20, color: textColor),
                  ),
                ],
              ),
              onPressed: () {
                print("Pressed: BPM");
                showModalBottomSheet<void>(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  context: context,
                  builder: (context) => BpmSetting(),
                ).then((_) => model.resetBpmTapCount());
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: !model.isPlaying
              ? IconButton(
                  color: textColor,
                  icon: Icon(Icons.play_arrow_rounded),
                  iconSize: bottomIconSIze,
                  onPressed: () async {
                    model.switchPlayStatus();
                    model.metronomeLoad();
                    print("Pressed: Play");
                    if (model.metronomeContainerStatus <
                        model.countInTimes - 1) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return CountInDialog();
                          });
                      await model
                          .waitUntilCountInEnds()
                          .then((_) => Navigator.of(context).pop());
                    }
                  },
                )
              : IconButton(
                  color: textColor,
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
            color: textColor,
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
