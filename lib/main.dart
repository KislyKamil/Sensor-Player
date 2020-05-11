import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors/sensors.dart';

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
  // IF music files are on other storage than sdcard1, it is required to change path manually!!
  static Directory dir = Directory('/storage/sdcard1/Music/');
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

    ///audioPosition();
    // audioDuration();
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

  void stopPlaying() {
    setState(() {
      if (audioPlayer.state != AudioPlayerState.STOPPED)
        isPlaying ? isPlaying = false : isPlaying = true;
      audioPlayer.stop();
    });
  }

  void nextTrack() {
    setState(() {
      startingPoint++;
      loadMusic(startingPoint);
    });
  }

  void previousTrack() {
    if (startingPoint > 0) {
      setState(() {
        startingPoint--;
        loadMusic(startingPoint);
      });
    } else {
      setState(() => loadMusic(0));
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
      body: Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'A',

                style: new TextStyle(fontSize:12.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              ),
              Text(
                'B',
                style: new TextStyle(fontSize:12.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              )
            ]

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton(
                    child: Icon(Icons.skip_previous),
                    backgroundColor: Colors.blueAccent,
                    onPressed: previousTrack,
                    heroTag: 'btn1',
                  ),
                  FloatingActionButton(
                      child: playIcon(),
                      backgroundColor: Colors.blueAccent,
                      onPressed: stopOrResume,
                      heroTag: 'btn2'),
                  FloatingActionButton(
                      child: Icon(Icons.skip_next),
                      backgroundColor: Colors.blueAccent,
                      onPressed: nextTrack,
                      heroTag: 'btn3'),
                  FloatingActionButton(
                    child: Icon(Icons.stop),
                    backgroundColor: Colors.indigo,
                    onPressed: stopPlaying,
                    heroTag: 'btn4',
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
  String currentPosition(){

  }
  String audioLength(){

    audioDuration();

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

  playIcon() {
    if (isPlaying) {
      return (Icon(Icons.pause));
    } else {
      return (Icon(Icons.play_arrow));
    }
  }
}
