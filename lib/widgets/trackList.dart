import 'package:flutter/material.dart';
import 'dart:io';

class TrackList extends StatelessWidget {
  TrackList({Key key, @required List<String> items}) : super(key: key) {
    this.items = items;
  }
  static Directory dir = Directory('/storage/sdcard1/muisc');
  List<String> items;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${items[index]}',
                    style: TextStyle(fontFamily: 'FredokaOne')),
                //onTap: (),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  color: Colors.indigo,
                  thickness: 1.5,
                )));
  }
}
