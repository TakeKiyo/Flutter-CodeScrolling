import 'dart:async';

import 'package:quiver/async.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void audioPlayerHandler(AudioPlayerState value) => null;

class MetronomeModel extends ChangeNotifier {
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

  AudioCache _metronomePlayer = AudioCache();
  AudioPlayer _audioPlayer = AudioPlayer();
  DateTime _metronomeCheck;
  String _metronomeSound = "metronome_digital1.wav";
  var _metronomeDuration;
  StreamSubscription<DateTime> _metronomeTimer;

  void metronomeModel() {
    print(DateTime.now().difference(_metronomeCheck).inMicroseconds);
    _metronomeCheck = DateTime.now();
    _metronomePlayer.play(_metronomeSound);
    _audioPlayer.monitorNotificationStateChanges(audioPlayerHandler);
  }

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
    metronomeReflect();
    notifyListeners();
  }

  void changeMuteStatus(bool _muteStatusValue) {
    _muteStatus = _muteStatusValue;
    print("MUTE BUTTON IS $_muteStatus");
    notifyListeners();
  }

  void bpmTapDetector() {
    if (_bpmTapCount == 0) {
      _bpmTapStartTime = DateTime.now();
      _bpmTapCount++;
      _bpmTapText = "BPM計測中...";
      notifyListeners();
    } else if (_bpmTapCount % 5 != 0) {
      var _bpmDetectNow = DateTime.now();
      var _bpmDetectDiff =
          _bpmDetectNow.difference(_bpmTapStartTime).inMilliseconds;
      _bpmCalculateList.add(_bpmDetectDiff);
      _bpmTapStartTime = _bpmDetectNow;
      _bpmTapCount++;
      if (_bpmTapCount == 5) {
        _bpmTapText = "計測終了";
        notifyListeners();
      }
    } else {
      int _bpmCalculateAverage = _bpmCalculateList.reduce(
              (_bpmDiffValue, _bpmDiffElement) =>
                  _bpmDiffValue + _bpmDiffElement) ~/
          _bpmCalculateList.length;
      _tempoCount = (60000 / _bpmCalculateAverage).floor();
      if (_tempoCount < 30) {
        _tempoCount = 30;
      }
      if (_tempoCount > 300) {
        _tempoCount = 300;
      }
      print("$_bpmCalculateList");
      resetBpmTapCount();
      notifyListeners();
      metronomeReflect();
    }
  }

  void resetBpmTapCount() {
    _bpmTapCount = 0;
    _bpmCalculateList = <int>[];
    _bpmTapText = "TAPで計測開始";
  }

  void metronomeLoad() {
    _metronomePlayer.load(_metronomeSound);
    _metronomePlayer.play(_metronomeSound);
  }

  void metronomeClear() {
    _metronomeTimer.cancel();
    _metronomePlayer.clear(_metronomeSound);
  }

  void metronomeStart() {
    _metronomeCheck = DateTime.now();
    _metronomeDuration = Duration(microseconds: (60000000 ~/ _tempoCount));
    _metronomeTimer = Metronome.periodic(_metronomeDuration).listen((metronomeTimer) => metronomeModel());
  }

  void metronomeReflect() {
    if (_isPlaying) {
      _metronomeTimer.cancel();
      metronomeStart();
    }
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      Provider.of<MetronomeModel>(context)._tempoCount.toString(),
      style: TextStyle(fontSize: 20),
    );
  }
}
