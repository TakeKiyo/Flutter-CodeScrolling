import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void audioPlayerHandler(AudioPlayerState value) => null;

class MetronomeModel extends ChangeNotifier {
  int _tempoCount;
  get tempoCount => _tempoCount;

  set tempoCount(int bpm) {
    if (bpm < 30)
      _tempoCount = 30;
    else if (bpm > 300)
      _tempoCount = 300;
    else
      _tempoCount = bpm;
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

  get metronomeSound => _metronomeSound;

  Color metronomeContainerColor;

  double _soundVolume = 1;
  get soundVolume => _soundVolume;

  ///初期値を-1にするとメトロノームが鳴る１回目に一番左(mod CountIn == 0になる)がフラッシュする
  int _metronomeContainerStatus = -1;
  get metronomeContainerStatus => _metronomeContainerStatus;

  int _countInTimes = 4;
  get countInTimes => _countInTimes;

  bool _isCountInPlaying = false;
  get isCountInPlaying => _isCountInPlaying;

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

  void changeSlider(double _slideValue) {
    _tempoCount = _slideValue.toInt();
    notifyListeners();
  }

  void bpmTapDetector() {
    const bpmMin = 30;
    const bpmMax = 300;
    const milliSeconds = 60000;

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
      _tempoCount = (milliSeconds / _bpmCalculateAverage).floor();
      if (_tempoCount < bpmMin) {
        _tempoCount = bpmMin;
      } else if (_tempoCount > bpmMax) {
        _tempoCount = bpmMax;
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

  void switchPlayStatus() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void forceStop() {
    metronomeClear();
    _isPlaying = false;
    _metronomeContainerStatus = -1;
    _metronomePlayer.clear(_metronomeSound);
    notifyListeners();
  }

  void metronomeLoad() async {
    await _metronomePlayer.load(_metronomeSound);
    notifyListeners();
    _isCountInPlaying = true;
    countInPlay();
  }

  void countInPlay() {
    const microseconds = 60000000;
    var _metronomeDuration =
        Duration(microseconds: (microseconds ~/ _tempoCount));

    ///カウントインを規定回数繰り返したらmetronomePlay()を呼び出す。一定Durationでメトロノームを鳴らしたいのでwhileで実装できない。
    if (_metronomeContainerStatus < _countInTimes - 1) {
      _metronomeTimer = Timer(_metronomeDuration, countInPlay);
      metronomeRingSound();
      changeMetronomeCountStatus();
    } else {
      //カウントインが終わる時にContainerStatusを初期値に戻す
      _isCountInPlaying = false;
      _metronomeContainerStatus = -1;
      notifyListeners();
      metronomePlay();
    }
  }

  void changeMetronomeCountStatus() {
    if (_isPlaying) {
      _metronomeContainerStatus++;
      notifyListeners();
    }
  }

  Future waitUntilCountInEnds() {
    const microseconds = 60000000;
    return Future.delayed(Duration(
        microseconds:

            ///カウントイン回数xBPM分の時間。ー0.5がないと一瞬だけカウントイン回数+1回目のFlashが起きてしまう
            (microseconds / _tempoCount * (_countInTimes - 0.5)).toInt()));
  }

  void metronomePlay() {
    const microseconds = 60000000;
    var _metronomeDuration =
        Duration(microseconds: (microseconds ~/ _tempoCount));
    _metronomeTimer = Timer(_metronomeDuration, metronomePlay);
    metronomeRingSound();
    changeMetronomeCountStatus();
  }

  void metronomeRingSound() {
    _metronomePlayer.play(_metronomeSound,
        volume: _soundVolume, isNotification: true);

    ///下記のコードが無いとiOSでのみエラーを吐く。
    _audioPlayer.monitorNotificationStateChanges(audioPlayerHandler);
  }

  void metronomeClear() {
    if (_isPlaying) {
      _metronomeTimer.cancel();
    }
  }

  void changeMuteStatus() {
    if (_soundVolume == 1) {
      _soundVolume = 0;
    } else {
      _soundVolume = 1;
    }
    _audioPlayer.setVolume(_soundVolume);
    notifyListeners();
  }
}
