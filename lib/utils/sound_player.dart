import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:async';

class SoundPlayer {
  String url;
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  SoundPlayer(this.url);

  get position => assetsAudioPlayer.currentPosition;

  get playing => assetsAudioPlayer.isPlaying;

  get current => assetsAudioPlayer.current;

  void toggle() {
    if (assetsAudioPlayer.current.value == null) return;
    assetsAudioPlayer.playOrPause();
  }

  void init() async {
    try {
      await assetsAudioPlayer.open(Audio.network(url),
          autoStart: false, loopMode: LoopMode.single);
    } catch (e) {
      print(e);
    }
  }

  void dispose() async {
    await assetsAudioPlayer.dispose();
  }
}
