import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_timer_model.dart';
import 'metronome_container.dart';

class CountInDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeTimerModel>(builder: (_, model, __) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 100,
          child: Center(
            child: ListView(
              shrinkWrap: true,
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
        ),
      );
    });
  }
}
