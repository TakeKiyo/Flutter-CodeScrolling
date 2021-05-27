import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/metronome_model.dart';

class VolumeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return SizedBox(
        height: 100,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Text("Volume",
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: IconButton(
                      icon: Icon(Icons.volume_down),
                      onPressed: model.volumeDown,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Slider(
                      label: model.soundVolume.toString(),
                      value: model.soundVolume,
                      divisions: 20,
                      min: 0,
                      max: 2,
                      onChanged: model.volumeChange,
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: model.volumeUp,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: TextButton(
                child: Text(
                  "return to Default",
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: model.volumeDefault,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class VolumeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      if (model.soundVolume == 0) {
        return Icon(Icons.volume_off);
      } else if (model.soundVolume < 1) {
        return Icon(Icons.volume_down);
      } else {
        return Icon(Icons.volume_up);
      }
    });
  }
}
