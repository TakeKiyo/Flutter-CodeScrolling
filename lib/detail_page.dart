import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CounterModel>(
      create: (_) => CounterModel(),
        child:Scaffold(
          appBar: AppBar(
              title: Text('Code Scrolling'),
          ),
          body: Consumer<CounterModel>(builder: (_, model, __) {
            return Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    tooltip: 'Decrement',
                    onPressed: model.decrement
                  ),
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
                    onPressed: model.increment
                  ),
                  ],
            ),
          );
          }),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: "BPM",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              label: "PLAY"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.stop),
                label:"STOP"
            ),
        ],
        ),
    ),
    );
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      Provider.of<CounterModel>(context).count.toString(),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class CounterModel extends ChangeNotifier {
  int count = 60;

  void increment() {
    count++;
    notifyListeners();
  }
  void decrement() {
    count--;
    notifyListeners();
  }
}
