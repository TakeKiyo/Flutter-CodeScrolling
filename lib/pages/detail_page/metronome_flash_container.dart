import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/metronome_model.dart';

class FlashContainer extends StatefulWidget {
  const FlashContainer({Key key}) : super(key: key);

  @override
  State<FlashContainer> createState() => FlashContainerState();
}

class FlashContainerState extends State<FlashContainer>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = AnimationController(
      duration: Duration(
          microseconds:
              60000000 ~/ Provider.of<MetronomeModel>(context).tempoCount),
      reverseDuration: const Duration(microseconds: 10000),
      vsync: this,
    )..repeat();

    return Provider.of<MetronomeModel>(context).isPlaying
        ? FadeTransition(
            opacity: _controller.drive(Tween(begin: 1.0, end: 0.0)),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.orangeAccent, shape: BoxShape.circle),
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
