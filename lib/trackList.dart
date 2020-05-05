

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class TrackList extends StatelessWidget {

  TrackList({Key key}): super(key: key);

  final items = List<String>.generate(10000, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
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
