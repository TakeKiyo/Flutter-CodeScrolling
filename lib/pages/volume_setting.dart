import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/metronome_model.dart';

class VolumeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Dialog(
          insetPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          child: SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Text("Volume",
                      style: TextStyle(
                        fontSize: 32,
                      )),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_down),
                        onPressed: (){

                        },
                      ),
                      Slider(
                        label: model.soundVolume.toString(),
                        value: model.soundVolume,
                        divisions: 20,
                        min: 0,
                        max: 2,
                        onChanged: model.volumeChange,
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: (){

                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
