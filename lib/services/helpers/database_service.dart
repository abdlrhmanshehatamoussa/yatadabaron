import 'package:sqflite/sqflite.dart';
import 'package:yatadabaron/simple/module.dart';

class NamedDatabaseSimpleService<T> extends SimpleService<T> {
  NamedDatabaseSimpleService({
    required this.databaseFilePath,
  });

  final String databaseFilePath;
  Database? _database;

  Future<Database> get database async {
    if (_database == null || (_database!.isOpen == false)) {
      _database = await openDatabase(databaseFilePath, readOnly: true);
    }
    if (_database!.isOpen == false) {
      throw Exception("Error openeing database !");
    }
    return _database!;
  }
}
