import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CounterModel>(
      create: (_) => CounterModel(),
        child:Consumer<CounterModel>(builder: (_, model, __) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Code Scrolling'),
              ),
              body:
              Center(
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

                ),
              persistentFooterButtons: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height:60,
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children:[
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
                              },
                            ),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.play_arrow),
                          iconSize: 36,
                            onPressed: (){
                              print("Pressed: Play");
                            },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.stop),
                          iconSize: 36,
                            onPressed: (){
                              print("Pressed: Stop");
                            },
                        ),
                      ),
                  ]))],

              );
        }),
    );
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      Provider.of<CounterModel>(context).count.toString(),
      style: TextStyle(fontSize: 20),
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
