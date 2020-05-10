import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:io';

import 'package:sensorplayer/trackList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Sensor Player',
      home: MyHomePage(title: 'Sensor Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  bool remote = true;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static Directory dir = Directory('/storage/sdcard1/muisc/');
  static List<FileSystemEntity> files = dir.listSync();
  final List<String> items = [];

  bool isPlaying = false;
  Duration duration, position;
  int startingPoint = 0;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  initState() {
    super.initState();
    listInit();
    audioComplete();
    audioPosition();
    audioDuration();

  }

  void listInit() {
    files.forEach((f) =>
        items.add(f.path.substring(23).replaceAll(RegExp('([.]mp3)'), '')));
  }

  audioDuration() async {
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => duration = d);
    });
  }

  audioPosition() async {
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() => position = p);

    });
  }

  /*onComplete(int index) async {

    audioPlayer.play('${dir.path}${items[index]}.mp3',
        isLocal: true, volume: 1.0);
  }

   */

  audioComplete() {
    audioPlayer.onPlayerCompletion.listen((event) {
      startingPoint++;
      loadMusic(startingPoint);
      setState(() {
        position = duration;
      });
    });
  }

  loadMusic(int index) async {
    if (isPlaying) {
      audioPlayer.play('${dir.path}${items[index]}.mp3',
          isLocal: true, volume: 1.0);
    } else {
      audioPlayer.pause();
    }
  }

  void stopOrResume() {
    setState(() {
      isPlaying ? isPlaying = false : isPlaying = true;
      loadMusic(startingPoint);
    });

  }

  playIcon() {
    if (isPlaying) {
      return (Icon(Icons.pause));
    } else {
      return (Icon(Icons.play_arrow));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Player ',
            style: TextStyle(fontFamily: 'PressStart2P', fontSize: 17)),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: showList,
            textTheme: ButtonTextTheme.normal,
            textColor: Colors.white,
            label: Text('songs'),
            icon: Icon(Icons.music_note),
          ),
        ],
      ),
      floatingActionButton:
          new FloatingActionButton(child: playIcon(), onPressed: stopOrResume),
    );
  }

  showList() {
    return Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Track catalog')),
          body: TrackList(items: items),
        );
      },
    ));
  }
}
