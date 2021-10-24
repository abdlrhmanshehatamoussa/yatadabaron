import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<String> initializeDatabase({
    required String dbAssetsDirectory,
    required String dbAssetsName,
  }) async {
    Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    String databaseFilePath = join(appDocumentDirectory.path, dbAssetsName);
    File databaseFile = File(databaseFilePath);
    bool exists = await databaseFile.exists();
    String databaseAssetsFilePath = join(dbAssetsDirectory, dbAssetsName);

    if (!exists) {
      //Create the writable database file from the bundled database file in the assets:
      ByteData databseByteData = await rootBundle.load(databaseAssetsFilePath);
      List<int> databseBytes = databseByteData.buffer.asUint8List(
          databseByteData.offsetInBytes, databseByteData.lengthInBytes);
      await databaseFile.writeAsBytes(databseBytes);
      exists = await databaseFile.exists();
    }
    if (!exists) {
      throw Exception(
          "Failed to create the database [$dbAssetsName] from the location [$databaseAssetsFilePath]");
    }
    return databaseFilePath;
  }
}
