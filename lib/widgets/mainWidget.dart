import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sensorplayer/player_service/player.dart';
import 'package:sensors/sensors.dart' as sens;
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:all_sensors/all_sensors.dart';
import 'package:sensorplayer/widgets/trackList.dart';

class MainWidget extends StatefulWidget {
  MainWidget({Key key, this.title, this.player}) : super(key: key);

  final String title;
  Player player;

  @override
  _MainWidgetState createState() =>
      _MainWidgetState(player: player, maxIndex: player.maxIndex);
}

class _MainWidgetState extends State<MainWidget> {
  _MainWidgetState({@required this.player, @required this.maxIndex});

  Duration duration = Duration(minutes: 0, seconds: 0);
  Duration position = Duration(minutes: 0, seconds: 0);
  int startingPoint = 0;
  int maxIndex;
  double xAxis, yAxis, zAxis;
  int counter = 0;

  bool isPlaying = false;
  bool isOn = true;
  bool isProximity = false;

  Player player;

  @override
  initState() {
    super.initState();
    print(player.items.length);
    print(maxIndex);
    audioCompleteState();
    audioPosition();
    audioDuration();
    axisState();
    isNear();
  }

  void isNear() {
    proximityEvents.listen((ProximityEvent event) {
      setState(() {
        isProximity = event.getValue();
      });
    });
  }

  void stopPlayingState() {
    if (isPlaying) {
      setState(() {
        isPlaying ? isPlaying = false : isPlaying = true;
        position = Duration(minutes: 0, seconds: 0);
        player.audioPlayer.stop();
      });
    } else if (!isPlaying) {
      setState(() {
        position = Duration(minutes: 0, seconds: 0);
        player.audioPlayer.stop();
      });
    }
  }

  void resetDuration() {
    duration = Duration(minutes: 0, seconds: 0);
    position = Duration(minutes: 0, seconds: 0);
  }

  audioCompleteState() {
    player.audioPlayer.onPlayerCompletion.listen((event) {
      startingPoint++;
      if (startingPoint == maxIndex) {
        startingPoint = 0;
      }
      player.loadMusic(startingPoint, isPlaying);
      setState(() {
        position = duration;
      });
    });
  }

  stopOrResumeState() {
    setState(() {
      isPlaying ? isPlaying = false : isPlaying = true;
      player.loadMusic(startingPoint, isPlaying);
    });
  }

  nextTrack() {
    setState(() {
      resetDuration();
      if (startingPoint == maxIndex - 1) {
        startingPoint = 0;
      } else {
        startingPoint++;
      }
      player.loadMusic(startingPoint, isPlaying);
    });
  }

  previousTrack() {
    if (startingPoint > 0) {
      setState(() {
        resetDuration();
        startingPoint--;
        player.loadMusic(startingPoint, isPlaying);
      });
    } else {
      setState(() {
        resetDuration();
        startingPoint = maxIndex - 1;
        player.loadMusic(startingPoint, isPlaying);
      });
    }
  }

  allowProximity() {
    if (isProximity) {
      player.audioPlayer.setVolume(0);
    } else {
      player.audioPlayer.setVolume(1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print('DURATION = $duration');
    print('POSITION = $position');
    print('STATE = ${player.audioPlayer.state}');

    if (isOn) {
      allowProximity();
    } else {
      setState(() {
        player.loadMusic(startingPoint, isPlaying);
      });
    }

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
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  key: null,
                  onPressed: setSensorsState,
                  color: const Color(0xFFe0e0e0),
                  child: Text(
                    isOn ? 'Sensors ON' : 'Sensors OFF',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Sriracha"),
                  )),
            ]),

        /* UNCOMMENT TO SHOW AXIS AND PROXIMITY
       Row(
          children: <Widget>[
            Text('Proximity = $isProximity'),
          ],
        ),
        Row(
          children: <Widget>[
            Text('X = $xAxis'),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Y = $yAxis'),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Z = $zAxis'),
          ],
        ),
        */
        Row(
          children: <Widget>[
            Text('${player.items[startingPoint]}'),
          ],
        ),
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
                      onPressed: stopOrResumeState,
                      heroTag: 'btn2'),
                  FloatingActionButton(
                      child: Icon(Icons.skip_next),
                      backgroundColor: Colors.blueAccent,
                      onPressed: nextTrack,
                      heroTag: 'btn3'),
                  FloatingActionButton(
                    child: Icon(Icons.stop),
                    backgroundColor: Colors.indigo,
                    onPressed: stopPlayingState,
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

  audioDuration() {
    player.audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => duration = d);
    });
  }

  audioPosition() {
    player.audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() => position = p);
    });
  }

  showList() {
    return Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Track catalog')),
          body: TrackList(items: player.items),
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

  axisState() {
    sens.accelerometerEvents.listen((sens.AccelerometerEvent event) {
      print(event);
      if (isOn) {
        if (event.x > 5.7 && event.y < 5 && counter == 0) {
          previousTrack();
          setState(() {
            counter = 1;
          });
        }

        if (event.x < -5.28 && event.y < 5 && counter == 0) {
          nextTrack();
          setState(() {
            counter = 1;
          });
        }

        if (event.x < 1.3 && event.x > -1.4) {
          setState(() {
            counter = 0;
          });
        }
      }
      setState(() {
        xAxis = event.x;
        yAxis = event.y;
        zAxis = event.z;
      });
    });
    //[AccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]
  }

  setSensorsState() {
    setState(() => isOn ? isOn = false : isOn = true);
  }
}
