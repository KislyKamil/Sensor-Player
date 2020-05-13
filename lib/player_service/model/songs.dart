import 'dart:io';

class Songs {
  Songs() {
    listInit();
  }
  // IF music files are on other storage than sdcard1, it is required to change path manually!!
  static Directory dir; //= Directory('/storage/sdcard1/Music/');
  static Directory phoneDir; // = Directory('/storage/sdcard0/Music/');
  // -->
  List<FileSystemEntity> files; // = dir.listSync();
  List<FileSystemEntity> phoneFiles; // = phoneDir.listSync();
  final List<String> items = [];
  final List<String> itemsPhone = [];
  int maxIndex;
  bool isCard = true;

  void checkDir() {
    try {
      dir = Directory('/storage/sdcard1/Music/');
      files = dir.listSync();
    } catch (e) {
      phoneDir = Directory('/storage/sdcard0/Music/');
      phoneFiles = phoneDir.listSync();
    }
  }

  listInit() async {
    checkDir();
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
