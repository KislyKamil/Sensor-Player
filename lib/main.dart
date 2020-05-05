import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static String path = '/storage/sdcard1/muisc/';
  bool isPlaying = false;

  Directory dir = Directory(path);
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  initState() {
    super.initState();

  }


  Future loadMusic() async {
    audioPlayer.play('${path}01 Cafe Belga.mp3',
        isLocal: true, volume: 1.0);

      if(!isPlaying) audioPlayer.stop();

  }


  void stopOrResume(){
    setState(() {
      isPlaying ? isPlaying= false: isPlaying = true;
      loadMusic();
    });
  }


  final items = List<String>.generate(10000, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sensor Player'),
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

          child: isPlaying ? Icon(Icons.pause): Icon(Icons.play_arrow),
          onPressed:  stopOrResume
      ),

    );
  }
  showList(){
    return Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Track catalog')),
          body: TrackList(),
        );
      },
    ));
  }

}

