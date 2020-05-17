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
  final List<String> _items = [];
  final List<String> _itemsPhone = [];
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

  List<String> get getItems {
    return _items;
  }

  String get getDir => dir.path;

  String get getPhoneDir => phoneDir.path;

  listInit() async {
    checkDir();
    if (files != null) {
      files.forEach((f) =>
          _items.add(f.path.substring(23).replaceAll(RegExp('([.]mp3)'), '')));
      maxIndex = _items.length;
    } else {
      isCard = false;
      if (phoneFiles != null) {
        phoneFiles.forEach((f) => _itemsPhone
            .add(f.path.substring(23).replaceAll(RegExp('([.]mp3)'), '')));
        maxIndex = _itemsPhone.length;
      }
    }
    _items.addAll(_itemsPhone);
    return _items;
  }
}
