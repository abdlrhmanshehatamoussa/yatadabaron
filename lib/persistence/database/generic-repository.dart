import 'package:sqflite/sqflite.dart';

import 'database-provider.dart';

class DatabaseRepository{
  Database? database;

  Future checkDB() async{
    if(database == null || (database!.isOpen == false)){
      database =  await DatabaseProvider.getDatabase();
      if(database!.isOpen == false){
        throw Exception("Error openeing database !");
      }
    }
  }
}