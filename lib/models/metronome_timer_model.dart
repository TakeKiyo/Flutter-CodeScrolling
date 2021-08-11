import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../models/metronome_bpm_model.dart';

void audioPlayerHandler(AudioPlayerState value) => null;

class MetronomeTimerModel extends ChangeNotifier {
  MetronomeBpmModel model = MetronomeBpmModel();

  AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioCache _metronomePlayer = AudioCache();
  Timer _metronomeTimer;

  String _metronomeSound = "metronome_digital1.wav";
  get metronomeSound => _metronomeSound;

  Color metronomeContainerColor;

  double _soundVolume = 1;
  get soundVolume => _soundVolume;

  ///初期値を-1にするとメトロノームが鳴る１回目に一番左(mod CountIn == 0になる)がフラッシュする
  int _metronomeContainerStatus = -1;
  get metronomeContainerStatus => _metronomeContainerStatus;

  int _countInTimes = 4;
  get countInTimes => _countInTimes;

  void metronomeLoad() async {
    await _metronomePlayer.load(_metronomeSound);
    countInPlay();
  }

  void countInPlay() {
    const microseconds = 60000000;
    var _metronomeDuration =
        Duration(microseconds: (microseconds ~/ model.tempoCount));

    ///カウントインを規定回数繰り返したらmetronomePlay()を呼び出す。一定Durationでメトロノームを鳴らしたいのでwhileで実装できない。
    if (_metronomeContainerStatus < _countInTimes - 1) {
      _metronomeTimer = Timer(_metronomeDuration, countInPlay);
      metronomeRingSound();
      countInChangeStatus();
      print(_metronomeContainerStatus);
    } else {
      metronomePlay();
    }
  }

  void countInChangeStatus() {
    if (model.isPlaying) {
      _metronomeContainerStatus++;
      notifyListeners();
    }
  }

  Future waitUntilCountInEnds() {
    const microseconds = 60000000;
    return Future.delayed(Duration(
        microseconds:

            ///カウントイン回数xBPM分の時間。ー0.5がないと一瞬だけカウントイン回数+1回目のFlashが起きてしまう
            (microseconds / model.tempoCount * (_countInTimes - 0.5)).toInt()));
  }

  void metronomePlay() {
    const microseconds = 60000000;
    var _metronomeDuration =
        Duration(microseconds: (microseconds ~/ model.tempoCount));
    _metronomeTimer = Timer(_metronomeDuration, metronomePlay);
    metronomeRingSound();
    countInChangeStatus();
    changeMetronomeContainerColor();
  }

  void metronomeRingSound() {
    _metronomePlayer.play(_metronomeSound,
        volume: _soundVolume, isNotification: true);

    ///下記のコードが無いとiOSでのみエラーを吐く。
    _audioPlayer.monitorNotificationStateChanges(audioPlayerHandler);
  }

  void changeMetronomeContainerColor() async {
    /// flashDuration=100000　はbpm=300（最大時）に合わせた数値
    const flashDuration = 100000;
    metronomeContainerColor = Colors.orange;
    notifyListeners();
    await Future.delayed(Duration(microseconds: flashDuration));
    metronomeContainerColor = null;
    notifyListeners();
  }

  void makeMetronomeContainerStatusDefault() {
    _metronomeContainerStatus = -1;
    notifyListeners();
  }

  void metronomeClear() {
    if (model.isPlaying) {
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
