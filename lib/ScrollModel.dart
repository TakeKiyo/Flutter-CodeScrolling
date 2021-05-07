import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScrollModel extends ChangeNotifier {
  int _tempoCount = 60;
  bool _isPlaying = false;
  get isPlaying => _isPlaying;
  get tempoCount => _tempoCount;

  void increment() {
    _tempoCount++;
    notifyListeners();
  }

  void decrement() {
    _tempoCount--;
    notifyListeners();
  }

  void switchPlayStatus() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void forceStop() {
    _isPlaying = false;
    notifyListeners();
  }

  void changeSlider(double e){
    _tempoCount = e.toInt();
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