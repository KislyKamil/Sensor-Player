import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';




class MusicFiles {

  static List<String> songs = [];
  static String files;
  static Future <List<FileSystemEntity>> k;
  Stream<FileSystemEntity> x;

  static final dir = Directory('/storage/sdcard1/muisc/');

  MusicFiles(){
    x = dir.list();
    k = x.toList();

  }





}