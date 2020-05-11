import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors/sensors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'dart:async';
import 'dart:io';
import 'dart:math';

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
  static Directory phoneDir = Directory('/storage/emulated/0/Music/');
  // -->
  static List<FileSystemEntity> files = dir.listSync();
  static List<FileSystemEntity> phoneFiles = phoneDir.listSync();
  final List<String> items = [];
  final List<String> itemsPhone = [];

  bool isPlaying = false;
  Duration duration = Duration(minutes: 0, seconds: 0);
  Duration position = Duration(minutes: 0, seconds: 0);
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

    phoneFiles.forEach((f) => itemsPhone
        .add(f.path.substring(23).replaceAll(RegExp('([.]mp3)'), '')));
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
    if (isPlaying) {
      setState(() {
        isPlaying ? isPlaying = false : isPlaying = true;
        position = Duration(minutes: 0, seconds: 0);
        audioPlayer.stop();
      });
    }
  }

  void resetDuration() {
    duration = Duration(minutes: 0, seconds: 0);
    position = Duration(minutes: 0, seconds: 0);
  }

  void nextTrack() {
    setState(() {
      resetDuration();
      startingPoint++;
      loadMusic(startingPoint);
    });
  }

  void previousTrack() {
    if (startingPoint > 0) {
      setState(() {
        resetDuration();
        startingPoint--;
        loadMusic(startingPoint);
      });
    } else {
      setState(() => loadMusic(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print('DURATION = $duration');
    print('POSITION = $position');
    print('STATE = ${audioPlayer.state}');

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
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${position.inMinutes}:${position.inSeconds - position.inMinutes * 60} /',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.teal,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Sriracha"),
              ),
              Text(
                ' ${duration.inMinutes}:${duration.inSeconds - duration.inMinutes * 60}',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.teal,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Sriracha"),
              )
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StepProgressIndicator(
              direction: Axis.horizontal,
              fallbackLength: width - 10,
              totalSteps: (duration.inSeconds > 0) ? duration.inSeconds : 10,
              currentStep: (position.inSeconds > 0) ? position.inSeconds : 0,
              size: 5,
              padding: 0,
              selectedColor: Colors.redAccent,
              unselectedColor: Colors.black12,
              roundedEdges: Radius.circular(10),
            ),
          ],
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
