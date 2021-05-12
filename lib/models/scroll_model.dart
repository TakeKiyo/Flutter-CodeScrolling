import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScrollModel extends ChangeNotifier {
  int _tempoCount = 60;
  get tempoCount => _tempoCount;

  bool _isPlaying = false;
  get isPlaying => _isPlaying;

  bool _muteStatus = false;
  get muteStatus => _muteStatus;

  DateTime _bpmTapStartTime;
  int _bpmTapCount = 0;
  var _bpmCalculateList = <int>[];
  String _bpmTapText = "TAPで計測開始";
  get bpmTapCount => _bpmTapCount;
  get bpmTapText => _bpmTapText;


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

  void changeMuteStatus(bool _muteStatusValue){
    _muteStatus = _muteStatusValue;
    print("MUTE BUTTON IS $_muteStatus");
    notifyListeners();
    }

  void bpmTapDetector(){

    if (_bpmTapCount == 0) {
      _bpmTapStartTime = DateTime.now();
      _bpmTapCount ++;
      _bpmTapText = "BPM計測中...";
      notifyListeners();
    }
    else if (_bpmTapCount % 5 != 0){
      var _bpmDetectNow = DateTime.now();
      var _bpmDetectDiff = _bpmDetectNow.difference(_bpmTapStartTime).inMilliseconds;
      _bpmCalculateList.add(_bpmDetectDiff);
      _bpmTapStartTime = _bpmDetectNow;
      _bpmTapCount ++;
      if (_bpmTapCount == 5) {
        _bpmTapText = "計測終了";
        notifyListeners();
      }
    }
    else{
      int _bpmCalculateAve = _bpmCalculateList.reduce(
          (_bpmDiffValue, _bpmDiffElement) => _bpmDiffValue + _bpmDiffElement) ~/ _bpmCalculateList.length;
      _tempoCount =  (60000 / _bpmCalculateAve).floor();
      if (_tempoCount < 30){_tempoCount = 30;}
      if (_tempoCount > 300){_tempoCount = 300;}
      print("$_bpmCalculateList");
      resetBpmTapCount();
      notifyListeners();
    }
  }

  void resetBpmTapCount(){
    _bpmTapCount = 0;
    _bpmCalculateList = <int>[];
    _bpmTapText = "TAPで計測開始";
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