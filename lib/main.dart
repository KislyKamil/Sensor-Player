import 'package:sensorplayer/player_service/player.dart';
import 'package:sensorplayer/widgets/mainWidget.dart';
import 'package:sensorplayer/player_service/model/songs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Songs songs = Songs();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Sensor Player',
      home: MainWidget(
        title: 'Sensor Player',
        player: Player(items: songs.getItems, maxIndex: songs.maxIndex, songs: songs),
      ),
    );
  }
}