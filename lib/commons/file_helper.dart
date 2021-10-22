import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileHelper {
  static Future<bool> exists(String fileName) async {
    String fullPath = await getAppFilePath(fileName);
    File file = File(fullPath);
    bool exists = await file.exists();
    return exists;
  }

  static Future<File> createAtTemp(String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String fullPath = join(tempDir.path, fileName);
    File file = File(fullPath);
    return file;
  }

  static Future<File> create(String fileName) async {
    String fullPath = await getAppFilePath(fileName);
    File file = File(fullPath);
    return file;
  }

  static Future<File?> getIfExists(String fileName) async {
    String fullPath = await getAppFilePath(fileName);
    File file = File(fullPath);
    bool fileExists = await exists(fileName);
    return fileExists ? file : null;
  }

  static Future<String> getAppFilePath(String fileName) async {
    Directory parentDirectory = await getApplicationDocumentsDirectory();
    String fullPath = join(parentDirectory.path, fileName);
    return fullPath;
  }
}