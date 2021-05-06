import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './ScrollModel.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code Scrolling'),
      ),
      body: DetailPageHome(),
      persistentFooterButtons: <Widget>[DetailFooter()],
    );
  }
}

class DetailPageHome extends StatelessWidget {
  const DetailPageHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollModel>(
      create: (_) => ScrollModel(),
      child: Consumer<ScrollModel>(builder: (_, model, __) {
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
    );
  }
}

class DetailFooter extends StatelessWidget {
  const DetailFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollModel>(
      create: (_) => ScrollModel(),
      child: Consumer<ScrollModel>(builder: (_, model, __) {
        return Container(
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
                  child: !model.isPlaying ? IconButton(
                    icon: Icon(Icons.play_arrow),
                    iconSize: 36,
                    onPressed: (){
                      model.switcher();
                      print("Pressed: Play");
                    },
                  ) : IconButton(
                        icon: Icon(Icons.pause),
                        iconSize: 36,
                        onPressed: (){
                        model.switcher();
                        print("Pressed: Pause");
                        },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.stop),
                      iconSize: 36,
                      onPressed: (){
                        model.forceStop();
                        print("Pressed: Stop");
                      },
                  ),
                ),
              ]));
      }),
    );
  }
}