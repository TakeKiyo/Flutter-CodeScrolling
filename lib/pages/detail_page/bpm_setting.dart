import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';

class BpmSetting extends StatelessWidget {
  final double tempoIconSize = 32;

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 10,
              child: Container(
                height: 5,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    child: Text(
                      "Tempo",
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    )),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(Icons.remove),
                          iconSize: tempoIconSize,
                          tooltip: 'Decrement',
                          onPressed: () {
                            model.tempoDown();
                          }),
                      Text(
                        model.tempoCount.toString(),
                        style: TextStyle(
                          fontSize: tempoIconSize * 2,
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          iconSize: tempoIconSize,
                          tooltip: 'Increment',
                          onPressed: () {
                            model.tempoUp();
                          }),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Slider(
                    label: null,
                    value: model.tempoCount.toDouble(),
                    divisions: 270,
                    min: 30,
                    max: 300,
                    onChangeStart: model.startSlider,
                    onChanged: model.changeSlider,
                    onChangeEnd: model.endSlider,
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
                          ? ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.error)
                          : ElevatedButton.styleFrom()),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
