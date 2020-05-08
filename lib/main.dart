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
  String name;
  bool s = false; //TODO test it!
  void setName(String name) => this.name = name;
  bool say() {
    //TODO make reset button state
    return s;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static Directory dir = Directory('/storage/sdcard1/muisc');
  static List<FileSystemEntity> files = dir.listSync();
  final List<String> items = [];

  bool isPlaying = false;

  AudioPlayer audioPlayer = AudioPlayer();
  String currentFile;

  @override
  initState() {
    super.initState();
    listInit();
  }

  void changeState() {
    //TODO Try another solution

    isPlaying = widget.say();
  }

  void listInit() {
    files.forEach((f) =>
        items.add(f.path.substring(23).replaceAll(RegExp('([.]mp3)'), '')));
  }

  setCurrentFile(String item) {
    this.currentFile = item;
  }

  String getFile() {
    return currentFile;
  }

  Future loadMusic() async {
    //audioPlayer.play('$PATH$currentFile', isLocal: true, volume: 1.0);

    if (!isPlaying) audioPlayer.stop();
  }

  void stopOrResume() {
    setState(() {
      isPlaying ? isPlaying = false : isPlaying = true;
      loadMusic();
    });
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
      floatingActionButton: new FloatingActionButton(
          child: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          onPressed: stopOrResume),
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
