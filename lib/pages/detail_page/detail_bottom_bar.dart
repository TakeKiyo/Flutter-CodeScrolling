import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'bpm_setting.dart';
import 'countin_dialog.dart';

Material detailBottomBar(BuildContext context) {
  final double bottomIconSIze = 36;

  return Material(
    elevation: 5.0,
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 70,
              child: Selector<MetronomeModel, Color>(
                selector: (context, model) => model.metronomeContainerColor,
                builder: (context, containerColor, child) => TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).splashColor),
                      backgroundColor:
                          MaterialStateProperty.all(containerColor),
                      shape: MaterialStateProperty.all(CircleBorder())),
                  child: child,
                  onPressed: () {
                    print("Pressed: BPM");
                    showModalBottomSheet<void>(
                      backgroundColor: Theme.of(context).canvasColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32.0))),
                      context: context,
                      builder: (context) => BpmSetting(),
                    ).then((_) =>
                        Provider.of<MetronomeModel>(context, listen: false)
                            .resetBpmTapCount());
                  },
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("BPM",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color)),
                    Selector<MetronomeModel, int>(
                        selector: (context, model) => model.tempoCount,
                        shouldRebuild: (exTempoCount, notifiedTempoCount) =>
                            exTempoCount != notifiedTempoCount,
                        builder: (context, tempoCount, child) => Text(
                              tempoCount.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).iconTheme.color),
                            )),
                  ],
                ),
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
                      icon: const Icon(Icons.play_arrow_rounded),
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
                        } else
                          Provider.of<MetronomeModel>(context, listen: false)
                              .metronomeStart();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.pause_rounded),
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
              icon: const Icon(Icons.stop_rounded),
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
                      icon: volumeIcon(soundVolume),
                      iconSize: bottomIconSIze,
                      onPressed: () {
                        Provider.of<MetronomeModel>(context, listen: false)
                            .changeMuteStatus();
                      },
                    )),
          ),
        ])),
  );
}

Icon volumeIcon(double soundVolume) {
  if (soundVolume == 0) {
    return const Icon(Icons.volume_off);
  } else {
    return const Icon(Icons.volume_up);
  }
}
