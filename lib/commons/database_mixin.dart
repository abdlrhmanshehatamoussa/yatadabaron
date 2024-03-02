import 'package:sqflite/sqflite.dart';
import 'package:yatadabaron/commons/constants.dart';

mixin DatabaseMixin {
  Database? _database;

  Future<Database> database(String databaseFilePath) async {
    if (_database == null || (_database!.isOpen == false)) {
      _database = await openDatabase(
        databaseFilePath,
        readOnly: true,
        version: Constants.ASSETS_DB_VERSION,
      );
    }
    if (_database!.isOpen == false) {
      throw Exception("Error openeing database !");
    }
    return _database!;
  }
}
