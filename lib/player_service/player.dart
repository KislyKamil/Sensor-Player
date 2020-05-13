import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensorplayer/player_service/model/songs.dart';


class Player{
  Player({this.items, this.maxIndex});

  static Directory dir = Directory('/storage/sdcard1/Music/');
  static Directory phoneDir = Directory('/storage/sdcard0/Music/');
  static Songs songs = Songs();
  int maxIndex;
  List<String> items;
  AudioPlayer audioPlayer = AudioPlayer();

  loadMusic(int index, bool isPlaying) async {
    if (songs.isCard) {
      if (isPlaying) {
        audioPlayer.play('${dir.path}${items[index]}.mp3',
            isLocal: true, volume: 1.0);
      } else {
        audioPlayer.pause();
      }
    } else {
      if (isPlaying) {
        audioPlayer.play('${phoneDir.path}${items[index]}.mp3',
            isLocal: true, volume: 1.0);
      } else {
        audioPlayer.pause();
      }
    }
  }
}
