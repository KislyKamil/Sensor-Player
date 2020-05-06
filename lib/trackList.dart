
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

class TrackList extends StatelessWidget {

  TrackList({Key key}): super(key: key);

  static Directory dir = Directory('/storage/sdcard1/muisc');

  static List<FileSystemEntity> files = dir.listSync();

  List<String> items = [];



  void listInit(){
      files.forEach((f) => items.add(f.path));
  }

  @override
  Widget build(BuildContext context) {
    listInit();
    return Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index]}'),
              onTap: null,
            );

          },
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.indigo, thickness: 1.5,)
        )
    );
  }
}
