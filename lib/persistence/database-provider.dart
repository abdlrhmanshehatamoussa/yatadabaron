import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String DB_NAME = 'quran_usmani_tafseer.db';
  static Future<String> databasePath() async {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String databasesPath = dbDirectory.path;
    String dbPath = join(databasesPath, DB_NAME);
    return dbPath;
  }

  static Future<Database> getDatabase() async {
    String databasesPath = await databasePath();
    Database db = await openDatabase(databasesPath, readOnly: true);
    return db;
  }

  static Future<bool> initialize() async {
    String databasesPath = await databasePath();
    File databaseFile = File(databasesPath);
    bool exists = await databaseFile.exists();
    if (!exists) {
      //Create the writable database file from the bundled demo database file:
      ByteData databseByteData = await rootBundle.load("assets/data/$DB_NAME");
      List<int> databseBytes = databseByteData.buffer.asUint8List(
          databseByteData.offsetInBytes, databseByteData.lengthInBytes);
      await databaseFile.writeAsBytes(databseBytes);
      exists = await databaseFile.exists();
    }
    return exists;
  }
}
