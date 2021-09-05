import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';

class CountInDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: 100,
        child: Center(
          child: Consumer<MetronomeModel>(builder: (_, model, __) {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.horizontal,
              children: List.generate(model.countInTimes, (cNum) => cNum)
                  .map((cNum) => Container(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 0.1,
                              ),
                              shape: BoxShape.circle,
                              color: model.metronomeContainerStatus >= 0
                                  ? (model.metronomeContainerStatus %
                                              model.countInTimes ==
                                          cNum)
                                      ? Colors.orange
                                      : Colors.white
                                  : Colors.white,
                            )),
                      ))
                  .toList(),
            );
          }),
        ),
      ),
    );
  }
}
