import 'dart:async';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';

class StorageHelper {

  /* path */

  static Future<String> get _localPath async {
    final documentsPath = await AndroidPathProvider.documentsPath;
    final directory = "$documentsPath/stretcherapp";
    final folder = Directory(directory);
    if (await folder.exists()) {
      // print("folder existe");
    } else {
      folder.create();
    }
    return directory;
  }

  static Future<File> get _localFile async{
    final path = await _localPath;
    return File("$path/fullDataList.txt");
  }

  static Future<File> get _localCutPointsFile async{
    final path = await _localPath;
    return File("$path/cutPointList.txt");
  }

  static Future<File> get _localNotesFile async{
    final path = await _localPath;
    return File("$path/notesFile.txt");
  }

  /* Read File */

  // static Future<String> readFromFile(String fileName) async {
  //   final file = await _getLocalFile(fileName);
  //   return file.readAsString();
  // }

  /* Write File */

  static Future<File> writeTextToFile(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  static Future<File> writeCutPointsToFile(String data) async {
    final file = await _localCutPointsFile;
    return file.writeAsString(data);
  }

  static Future<File> writeNotesToFile(String data) async {
    final file = await _localNotesFile;
    return file.writeAsString(data);
  }

  static Future<String> localDocs() async {
    String documentsPath = await AndroidPathProvider.documentsPath;
    return documentsPath;
  }

  // static Future<File> writeBytesToFile(String fileName, Uint8List data) async {
  //   final file = await _getLocalFile(fileName);
  //   return file.writeAsBytes(data);
  // }
}
