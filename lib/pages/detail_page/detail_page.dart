import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';
import 'metronome_container.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;

  DetailPage({Key key, this.bpm, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                model.forceStop();
              }),
          title: Text(title),
          actions: <Widget>[],
        ),
        body: Center(
          /*
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(bpm.toString()),
            ],
          ),
           */
          child: ListView(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            children: List.generate(model.countInTimes, (cNum) => cNum)
                .map((cNum) => Container(
                      padding: EdgeInsets.all(5),
                      child: MetronomeContainerWidget(
                          contentState: cNum, contentNum: model.countInTimes),
                    ))
                .toList(),
          ),
        ),
        bottomNavigationBar: detailBottomBar(context, model),
      );
    });
  }
}
