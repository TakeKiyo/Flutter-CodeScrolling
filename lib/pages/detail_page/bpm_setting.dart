import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';

class BpmSetting extends StatelessWidget {
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
                    child: const Text(
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
                          icon: const Icon(Icons.remove),
                          iconSize: 32,
                          tooltip: 'Decrement',
                          onPressed: () {
                            model.tempoDown();
                          }),
                      Text(
                        model.tempoCount.toString(),
                        style: const TextStyle(fontSize: 64),
                      ),
                      IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 32,
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
                          style: const TextStyle(fontSize: 24)),
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
