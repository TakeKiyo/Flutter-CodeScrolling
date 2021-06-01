import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';

class BpmSetting extends StatelessWidget {
  final double tempoIconSize = 32;
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: Text(
                  "Tempo",
                  style: TextStyle(
                    fontSize: 32,
                    color: textColor,
                  ),
                )),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: textColor,
                      icon: Icon(Icons.remove),
                      iconSize: tempoIconSize,
                      tooltip: 'Decrement',
                      onPressed: () {
                        model.decrement();
                      }),
                  Text(
                    model.tempoCount.toString(),
                    style: TextStyle(fontSize: tempoIconSize * 2,
                      color: textColor,),
                  ),
                  IconButton(
                    color: textColor,
                      icon: Icon(Icons.add),
                      iconSize: tempoIconSize,
                      tooltip: 'Increment',
                      onPressed: () {
                        model.increment();
                      }),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Slider(
                activeColor: textColor,
                inactiveColor: Theme.of(context).primaryColorDark,
                label: null,
                value: model.tempoCount.toDouble(),
                divisions: 270,
                min: 30,
                max: 300,
                onChanged: model.changeSlider,
              ),
            ),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () {
                    model.bpmTapDetector();
                  },
                  child: Text(model.bpmTapText,
                      style: TextStyle(fontSize: tempoIconSize * 0.75)),
                  style: model.bpmTapCount % 5 != 0
                      ? ElevatedButton.styleFrom(primary: Colors.red)
                      : ElevatedButton.styleFrom()),
            ),
          ],
        ),
      );
    });
  }
}
