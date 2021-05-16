import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/metronome_model.dart';

class BpmSetting extends StatelessWidget {
  final double tempoIconSize = 32;

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  "Tempo",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(Icons.remove),
                            iconSize: tempoIconSize,
                            tooltip: 'Decrement',
                            onPressed: (){
                              model.decrement();
                            }),
                        Text(
                          Provider.of<MetronomeModel>(context)
                              .tempoCount
                              .toString(),
                          style: TextStyle(fontSize: tempoIconSize * 2),
                        ),
                        IconButton(
                            icon: Icon(Icons.add),
                            iconSize: tempoIconSize,
                            tooltip: 'Increment',
                            onPressed: (){
                              model.increment();
                            }),
                      ],
                    ),
                    Slider(
                      label: null,
                      value: model.tempoCount.toDouble(),
                      divisions: 270,
                      min: 30,
                      max: 300,
                      onChanged: model.changeSlider,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        model.bpmTapDetector();
                      },
                      child:Text(model.bpmTapText,
                              style: TextStyle(fontSize: tempoIconSize * 0.75)),
                      style: model.bpmTapCount % 5 != 0
                        ? ElevatedButton.styleFrom(primary: Colors.red)
                          : ElevatedButton.styleFrom()
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
