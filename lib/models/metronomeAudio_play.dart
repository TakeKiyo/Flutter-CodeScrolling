import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class MetronomeAudioPlay {
  static AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY)
    ..setReleaseMode(ReleaseMode.STOP);

  static AudioCache metronomePlayer = AudioCache();

  static Future<void> loadAll(List<String> metronomeSoundList) async {
    await metronomePlayer.loadAll(metronomeSoundList);
  }

  static void audioPlayerHandler(AudioPlayerState value) => null;

  static void play(String metronomeSound, double soundVolume) async {
    metronomePlayer.play(metronomeSound,
        volume: soundVolume,
        mode: PlayerMode.LOW_LATENCY,
        stayAwake: true,
        isNotification: true);
    audioPlayer.monitorNotificationStateChanges(audioPlayerHandler);
  }

  static void clearCache() {
    metronomePlayer?.clearCache();
  }

  static void setVolume(double soundVolume) {
    audioPlayer.setVolume(soundVolume);
  }
}
