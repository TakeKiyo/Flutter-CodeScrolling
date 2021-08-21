import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

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

  AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY)
    ..setReleaseMode(ReleaseMode.STOP);
  AudioCache _metronomePlayer;
  String _metronomeSound = "sounds/Metronome.wav";
  List<String> _metronomeSoundList = [
    "sounds/Metronome.wav",
    "sounds/ClickLayer808.wav",
    "sounds/Woodblock5.wav",
  ];
  Metronome _metronomeTimer;
  StreamSubscription<DateTime> _metronomeSubscription;

  get metronomeSound => _metronomeSound;
  get metronomeSoundList => _metronomeSoundList;

  set metronomeSound(int index) {
    _metronomeSound = _metronomeSoundList[index];
  }

  Color _metronomeContainerColor;
  get metronomeContainerColor => _metronomeContainerColor;

  double _soundVolume = 1;
  get soundVolume => _soundVolume;

  ///初期値を-1にするとメトロノームが鳴る１回目に一番左(mod CountIn == 0になる)がフラッシュする
  int _metronomeContainerStatus = -1;
  get metronomeContainerStatus => _metronomeContainerStatus;

  int _countInTimes = 4;
  get countInTimes => _countInTimes;

  bool _isCountInPlaying = false;
  get isCountInPlaying => _isCountInPlaying;

  Timer _tempoTapTimer;

  void tempoUp() {
    if (_tempoCount < 300) {
      _metronomeSubscription?.cancel();
      _tempoTapTimer?.cancel();
      _tempoCount++;
      notifyListeners();
      if (_isPlaying) {
        ///最後にボタンを押されてから0.5秒後にmetronomeを再開
        _tempoTapTimer =
            Timer(const Duration(milliseconds: 500), metronomeStart);
      }
    }
  }

  void tempoDown() {
    if (_tempoCount > 30) {
      _metronomeSubscription?.cancel();
      _tempoTapTimer?.cancel();
      _tempoCount--;
      notifyListeners();
      if (_isPlaying) {
        ///最後にボタンを押されてから0.5秒後にmetronomeを再開
        _tempoTapTimer =
            Timer(const Duration(milliseconds: 500), metronomeStart);
      }
    }
  }

  void startSlider(double _slideValue) {
    _metronomeSubscription?.cancel();
    _tempoCount = _slideValue.toInt();
    notifyListeners();
  }

  void changeSlider(double _slideValue) {
    _tempoCount = _slideValue.toInt();
    notifyListeners();
  }

  void endSlider(double _slideValue) {
    _tempoCount = _slideValue.toInt();
    notifyListeners();
    if (_isPlaying) {
      metronomeStart();
    }
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
    _metronomePlayer = AudioCache(fixedPlayer: _audioPlayer);
    await _metronomePlayer.load(_metronomeSound);
    _isCountInPlaying = true;
    notifyListeners();
    metronomeStart();
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
        microseconds: (microseconds / _tempoCount * (_countInTimes)).toInt()));
  }

  void metronomeStart() {
    const microseconds = 60000000;
    var _metronomeDuration =
        Duration(microseconds: (microseconds ~/ _tempoCount));
    _metronomeTimer = Metronome.epoch(_metronomeDuration);
    _metronomeSubscription =
        _metronomeTimer.listen((d) => metronomeRingSound());
  }

  void metronomeRingSound() {
    _metronomePlayer.play(_metronomeSound,
        volume: _soundVolume,
        mode: PlayerMode.LOW_LATENCY,
        stayAwake: true,
        isNotification: true);

    ///下記のコードが無いとiOSでのみエラーを吐く。
    _audioPlayer.monitorNotificationStateChanges(audioPlayerHandler);

    changeMetronomeCountStatus();
    changeMetronomeContainerColor();

    ///カウントインの処理
    if (_isCountInPlaying && metronomeContainerStatus == _countInTimes) {
      _isCountInPlaying = !_isCountInPlaying;
      _metronomeContainerStatus = 0;
    }
  }

  void changeMetronomeContainerColor() async {
    /// flashDuration=100000　はbpm=300（最大時）に合わせた数値
    const flashDuration = 100000;
    _metronomeContainerColor = Colors.orange;
    notifyListeners();
    await Future.delayed(Duration(microseconds: flashDuration));
    _metronomeContainerColor = Colors.transparent;
    notifyListeners();
  }

  void metronomeClear() {
    _metronomeSubscription?.cancel();
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
