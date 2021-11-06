import 'package:sqflite/sqflite.dart';

mixin DatabaseMixin {
  Database? _database;

  Future<Database> database(String databaseFilePath) async {
    if (_database == null || (_database!.isOpen == false)) {
      _database = await openDatabase(databaseFilePath, readOnly: true);
    }
    if (_database!.isOpen == false) {
      throw Exception("Error openeing database !");
    }
    return _database!;
  }
}
