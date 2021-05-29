import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void audioPlayerHandler(AudioPlayerState value) => null;

class MetronomeModel extends ChangeNotifier {
  int _tempoCount = 60;

  get tempoCount => _tempoCount;

  set tempoCount(int streamReceivedBpm){
    if (streamReceivedBpm < 30){
      _tempoCount = 30;
    }
    else if (streamReceivedBpm > 300){
      _tempoCount = 300;
    }
    else {
      _tempoCount = streamReceivedBpm;
    }
  }

  bool _isPlaying = false;

  get isPlaying => _isPlaying;

  DateTime _bpmTapStartTime;
  int _bpmTapCount = 0;
  var _bpmCalculateList = <int>[];
  String _bpmTapText = "TAPで計測開始";

  get bpmTapCount => _bpmTapCount;

  get bpmTapText => _bpmTapText;

  AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioCache _metronomePlayer = AudioCache();
  String _metronomeSound = "metronome_digital1.wav";
  Timer _metronomeTimer;

  double _soundVolume = 1;

  get soundVolume => _soundVolume;

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
    metronomeClear();
    _isPlaying = false;
    notifyListeners();
  }

  void changeSlider(double _slideValue) {
    _tempoCount = _slideValue.toInt();
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
      } else if (_tempoCount > 300) {
        _tempoCount = 300;
      }
      print("$_bpmCalculateList");
      resetBpmTapCount();
      notifyListeners();
    }
  }

  void resetBpmTapCount() {
    _bpmTapCount = 0;
    _bpmCalculateList = <int>[];
    _bpmTapText = "TAPで計測開始";
  }

  void metronomeLoad() async {
    await _metronomePlayer.load(_metronomeSound);
    metronomePlay();
  }

  void metronomePlay() {
    var _metronomeDuration = Duration(microseconds: (60000000 ~/ _tempoCount));
    _metronomeTimer = Timer(_metronomeDuration, metronomePlay);
    _metronomePlayer.play(_metronomeSound,
        volume: _soundVolume, isNotification: true);
    _audioPlayer.monitorNotificationStateChanges(audioPlayerHandler);
  }

  void metronomeClear() {
    if (_isPlaying) {
      _metronomeTimer.cancel();
      _metronomePlayer.clear(_metronomeSound);
    }
  }

  void volumeChange(double _volumeValue) {
    _soundVolume = _volumeValue;
    _audioPlayer.setVolume(_volumeValue);
    notifyListeners();
  }

  void volumeUp() {
    if (_soundVolume <= 1.9) {
      _soundVolume = _soundVolume + 0.1;
    } else {
      _soundVolume = 2;
    }
    notifyListeners();
  }

  void volumeDown() {
    if (_soundVolume >= 0.1) {
      _soundVolume = _soundVolume - 0.1;
    } else {
      _soundVolume = 0;
    }
    notifyListeners();
  }

  void volumeDefault() {
    _soundVolume = 1;
    notifyListeners();
  }
}
