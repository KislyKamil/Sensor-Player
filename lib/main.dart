import 'dart:convert';

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

  String path = '/storage/sdcard1/muisc';
  static Directory dir = Directory('/storage/sdcard1/muisc');
  bool isPlaying = false;


  AudioPlayer audioPlayer = AudioPlayer();

  static List<FileSystemEntity> files = dir.listSync();
  //TESTING
// String xd = files[0].path;

 List<String> items = [];




  @override
  initState() {
    super.initState();

    files.forEach((f) => items.add(f.path));

    //print(stuff.length);


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


  //final items = List<String>.generate(10000, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sensor Player '),
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
        /*body:  Center(
          child: ListView.separated(
          padding: const EdgeInsets.all(8),
           itemCount: items.length,
          itemBuilder: (context, index) {
               return ListTile(
                    title: Text('${items[index]}'),
                onTap: null,
              ) ;

            },
               separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.indigo, thickness: 1.5,)
           )
          ),

         */
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

