import 'package:audioplayers/audioplayers.dart';
import 'package:sensorplayer/player_service/model/songs.dart';

class Player {
  Player({this.items, this.maxIndex, this.songs});

  Songs songs;
  int maxIndex;
  List<String> items;
  AudioPlayer audioPlayer = AudioPlayer();

  loadMusic(int index, bool isPlaying) async {
    if (songs.isCard) {
      if (isPlaying) {
        audioPlayer.play('${songs.getDir}${items[index]}.mp3',
            isLocal: true, volume: 1.0);
      } else {
        audioPlayer.pause();
      }
    } else {
      if (isPlaying) {
        audioPlayer.play('${songs.getPhoneDir}${items[index]}.mp3',
            isLocal: true, volume: 1.0);
      } else {
        audioPlayer.pause();
      }
    }
  }
}
