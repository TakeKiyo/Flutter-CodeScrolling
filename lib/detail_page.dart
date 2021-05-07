import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './ScrollModel.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Code Scrolling'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.remove),
                  tooltip: 'Decrement',
                  onPressed: model.decrement),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'BPM:',
                  ),
                  CounterText(),
                ],
              ),
              IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'Increment',
                  onPressed: model.increment),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("BPM:"),
                                CounterText(),
                              ],
                            ),
                            onPressed: () {
                              print("Pressed: BPM");
                              showDialog<void>(
                                context: context,
                                builder: (_) {
                                  return BpmSetting();
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: !model.isPlaying
                              ? IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  iconSize: 36,
                                  onPressed: () {
                                    model.switchPlayStatus();
                                    print("Pressed: Play");
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.pause),
                                  iconSize: 36,
                                  onPressed: () {
                                    model.switchPlayStatus();
                                    print("Pressed: Pause");
                                  },
                                ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.stop),
                            iconSize: 36,
                            onPressed: () {
                              model.forceStop();
                              print("Pressed: Stop");
                            },
                          ),
                        ),
              ])),
        ],
      );
    });
  }
}

class BpmSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollModel>(builder: (_, model, __) {
      return Dialog(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 2 / 3,
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
                            iconSize: 36,
                            tooltip: 'Decrement',
                            onPressed: model.decrement),
                        Text(
                          Provider.of<ScrollModel>(context)
                              .tempoCount
                              .toString(),
                          style: TextStyle(fontSize: 64),
                        ),
                        IconButton(
                            icon: Icon(Icons.add),
                            iconSize: 36,
                            tooltip: 'Increment',
                            onPressed: model.increment),
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
                          print("Tapped");
                        },
                        child: Text("TAP", style: TextStyle(fontSize: 24))),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    TextButton(
                      child: Text("Example"),
                      onPressed: () {},
                    ),
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
