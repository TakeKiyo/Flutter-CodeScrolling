import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './ScrollModel.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollModel>(
        create: (_) => ScrollModel(),
        child: Consumer<ScrollModel>(builder: (_, model, __) {
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
                  child: Row(
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
                              return Container(
                                    height: 500,
                                    color: Colors.white,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    icon: Icon(Icons.remove),
                                                    tooltip: 'Decrement',
                                                    onPressed: model.decrement),
                                                Text(model.tempoCount.toString()),
                                                IconButton(
                                                    icon: Icon(Icons.add),
                                                    tooltip: 'Increment',
                                                    onPressed: model.increment),
                                              ],
                                            ),
                                          ),
                                          const Text('BottomSheet'),
                                          ElevatedButton(
                                              child: const Text(
                                                  'Close BottomSheet'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      ),
                                    ),
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
                                    model.switcher();
                                    print("Pressed: Play");
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.pause),
                                  iconSize: 36,
                                  onPressed: () {
                                    model.switcher();
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
        }));
  }
}
