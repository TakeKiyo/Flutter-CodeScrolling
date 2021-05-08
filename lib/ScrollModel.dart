import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScrollModel extends ChangeNotifier {
  int _tempoCount = 60;
  bool _isPlaying = false;
  get isPlaying => _isPlaying;
  get tempoCount => _tempoCount;
  bool _muteSwitch = false;
  get muteSwitch => _muteSwitch;
  DateTime _bpmTapStartTime;
  int _bpmTapCount = 0;

  void increment() {
    if (_tempoCount < 300) {
      _tempoCount++;
    }
    notifyListeners();
  }

  void decrement() {
    if (_tempoCount > 30) {
      _tempoCount--;
    }
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

  void changeSlider(double _slideValue) {
    _tempoCount = _slideValue.toInt();
    notifyListeners();
  }

  void changeMuteSwitch(bool _muteSwitchValue){
    _muteSwitch = _muteSwitchValue;
    print("MUTE BUTTON IS $_muteSwitch");
    notifyListeners();
    }

  void bpmTapDetector(){

    if (_bpmTapCount == 0) {
      _bpmTapStartTime = DateTime.now();
      _bpmTapCount = 1;
    }
    else{
      var _bpmDetectNow = DateTime.now();
      var _bpmDetectDiff = _bpmDetectNow.difference(_bpmTapStartTime).inMilliseconds;
      _bpmTapStartTime = _bpmDetectNow;
      int _detectedBpm =  (60000 / _bpmDetectDiff).floor();
      _tempoCount = _detectedBpm;
      if (_tempoCount < 30){_tempoCount = 30;}
      if (_tempoCount > 300){_tempoCount = 300;}
      print("$_bpmDetectDiff");
      notifyListeners();
    }
  }

  void resetBpmTapCount(){
    _bpmTapCount = 0;
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