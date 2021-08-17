import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/detail_page/metronome_flash_container.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'bpm_setting.dart';
import 'countin_dialog.dart';

Container detailBottomBar(BuildContext context) {
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                FlashContainer(),
                TextButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("BPM", style: TextStyle(color: textColor)),
                      Selector<MetronomeModel, int>(
                          selector: (context, model) => model.tempoCount,
                          shouldRebuild: (exTempoCount, notifiedTempoCount) =>
                              exTempoCount != notifiedTempoCount,
                          builder: (context, tempoCount, child) => Text(
                                tempoCount.toString(),
                                style:
                                    TextStyle(fontSize: 20, color: textColor),
                              )),
                    ],
                  ),
                  onPressed: () {
                    print("Pressed: BPM");
                    showModalBottomSheet<void>(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      context: context,
                      builder: (context) => BpmSetting(),
                    ).then((_) =>
                        Provider.of<MetronomeModel>(context, listen: false)
                            .resetBpmTapCount());
                  },
                ),
              ],
            ),
          ),
        ),
        Selector<MetronomeModel, bool>(
          selector: (context, model) => model.isPlaying,
          shouldRebuild: (exIsPlaying, notifiedIsPlaying) =>
              exIsPlaying != notifiedIsPlaying,
          builder: (context, isPlaying, __) => Expanded(
            flex: 1,
            child: !isPlaying
                ? IconButton(
                    color: textColor,
                    icon: Icon(Icons.play_arrow_rounded),
                    iconSize: bottomIconSIze,
                    onPressed: () async {
                      Provider.of<MetronomeModel>(context, listen: false)
                          .switchPlayStatus();
                      print("Pressed: Play");
                      if (Provider.of<MetronomeModel>(context, listen: false)
                              .metronomeContainerStatus ==
                          -1) {
                        Provider.of<MetronomeModel>(context, listen: false)
                            .metronomeLoad();
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CountInDialog();
                            });
                        await Provider.of<MetronomeModel>(context,
                                listen: false)
                            .waitUntilCountInEnds()
                            .then((_) => Navigator.of(context).pop());
                      } else {
                        Provider.of<MetronomeModel>(context, listen: false)
                            .metronomePlay();
                      }
                    },
                  )
                : IconButton(
                    color: textColor,
                    icon: Icon(Icons.pause_rounded),
                    iconSize: bottomIconSIze,
                    onPressed: () {
                      Provider.of<MetronomeModel>(context, listen: false)
                          .metronomeClear();
                      Provider.of<MetronomeModel>(context, listen: false)
                          .switchPlayStatus();
                      print("Pressed: Pause");
                    },
                  ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            color: textColor,
            icon: Icon(Icons.stop_rounded),
            iconSize: bottomIconSIze,
            onPressed: () {
              Provider.of<MetronomeModel>(context, listen: false).forceStop();
              print("Pressed: Stop");
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Selector<MetronomeModel, double>(
              selector: (context, model) => model.soundVolume,
              shouldRebuild: (exSoundValue, notifiedSoundValue) =>
                  exSoundValue != notifiedSoundValue,
              builder: (context, soundVolume, __) => IconButton(
                    color: textColor,
                    icon: volumeIcon(soundVolume),
                    iconSize: bottomIconSIze,
                    onPressed: () {
                      Provider.of<MetronomeModel>(context, listen: false)
                          .changeMuteStatus();
                    },
                  )),
        ),
      ]));
}

Icon volumeIcon(double soundVolume) {
  if (soundVolume == 0) {
    return Icon(Icons.volume_off, color: Colors.white);
  } else {
    return Icon(Icons.volume_up, color: Colors.white);
  }
}
