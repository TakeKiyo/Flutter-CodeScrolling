import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';
import 'detail_bottom_bar.dart';
import 'detail_edit_page.dart';

class DetailPage extends StatelessWidget {
  final int bpm;
  final String title;
  final String docId;

  DetailPage({Key key, this.bpm, this.title, this.docId}) : super(key: key);

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(bpm.toString()),
              TextButton(
                  onPressed: () {
                    Provider.of<MetronomeModel>(context, listen: false)
                        .tempoCount = bpm;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailEditPage(
                            bpm: bpm,
                            title: title,
                          );
                        },
                      ),
                    );
                  },
                  child: Text("コードや歌詞を編集する"))
            ],
          ),
        ),
        bottomNavigationBar: detailBottomBar(context, model),
      );
    });
  }
}
