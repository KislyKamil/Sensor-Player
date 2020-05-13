import 'dart:io';

class Songs {
  Songs() {
    listInit();
  }
  // IF music files are on other storage than sdcard1, it is required to change path manually!!
  static Directory dir;

  static Directory phoneDir = Directory('/storage/sdcard0/Music/');
  // -->
  List<FileSystemEntity> files;
  List<FileSystemEntity> phoneFiles = phoneDir.listSync();
  final List<String> items = [];
  final List<String> itemsPhone = [];
  int maxIndex;
  bool isCard = true;

  listInit() async {

    try{
      Directory('/storage/sdcard1/Muasic/');
    }on FileSystemException catch(e){
      dir = Directory('/storage/sdcard1/Music/');
      List<FileSystemEntity> files = dir.listSync();
      files = dir.listSync();
    }
    if (files != null) {
      files.forEach((f) =>
          items.add(f.path.substring(23).replaceAll(RegExp('([.]mp3)'), '')));
      maxIndex = items.length;
    } else {
      isCard = false;
      if (phoneFiles != null) {
        phoneFiles.forEach((f) => itemsPhone
            .add(f.path.substring(23).replaceAll(RegExp('([.]mp3)'), '')));
        maxIndex = itemsPhone.length;
      }
    }
    items.addAll(itemsPhone);
    return items;
  }
}
