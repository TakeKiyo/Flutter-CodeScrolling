import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';

class MetronomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MetronomeContainerWidget(contentState: 0, contentNum: 2),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          ),
          MetronomeContainerWidget(contentState: 1, contentNum: 2),
        ],
      );
    });
  }
}

class MetronomeContainerWidget extends StatelessWidget {
  final int contentState;
  final int contentNum;

  MetronomeContainerWidget({Key key, this.contentState, this.contentNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeModel>(builder: (_, model, __) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 0.1,
            ),
            shape: BoxShape.circle,
            color: !model.isPlaying
                ? Colors.white
                : (model.metronomeContainerStatus % contentNum == contentState
                    ? Colors.orange
                    : Colors.white)),
      );
    });
  }
}
