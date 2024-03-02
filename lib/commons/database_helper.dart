import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<String> initializeDatabase({
    required String dbAssetsDirectory,
    required String dbAssetsName,
    required int dbVersion,
  }) async {
    Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    String databaseFilePath = join(appDocumentDirectory.path, dbAssetsName);

    if (!await _openVersionedDb(databaseFilePath, dbVersion)) {
      await _rewriteDB(
        databaseAssetsFilePath: join(dbAssetsDirectory, dbAssetsName),
        databaseFilePath: databaseFilePath,
      );
    }
    return databaseFilePath;
  }

  static Future<bool> _openVersionedDb(
    String databaseFilePath,
    int version,
  ) async {
    Database? db;
    try {
      db = await openDatabase(
        databaseFilePath,
        readOnly: true,
        version: version,
      );
      return (await db.getVersion()) == version;
    } catch (e) {
      return false;
    } finally {
      db?.close();
    }
  }

  static Future<void> _rewriteDB({
    required String databaseAssetsFilePath,
    required String databaseFilePath,
  }) async {
    try {
      ByteData databseByteData = await rootBundle.load(databaseAssetsFilePath);
      List<int> databseBytes = databseByteData.buffer.asUint8List(
          databseByteData.offsetInBytes, databseByteData.lengthInBytes);
      File file = File(databaseFilePath);
      await file.writeAsBytes(databseBytes, mode: FileMode.write);
    } catch (e) {
      throw Exception(
        "Failed to create the database at [$databaseFilePath] from the location [$databaseAssetsFilePath], Error: ${e.toString()}",
      );
    }
  }
}
