import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScrollModel extends ChangeNotifier {
  int _tempoCount = 60;
  bool _isPlaying = false;
  get isPlaying => _isPlaying;

  void increment() {
    _tempoCount++;
    notifyListeners();
  }

  void decrement() {
    _tempoCount--;
    notifyListeners();
  }

  void switcher() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void forceStop(){
    _isPlaying = false;
    notifyListeners();
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      Provider.of<ScrollModel>(context)._tempoCount.toString(),
      style: TextStyle(fontSize: 20),
    );
  }
}