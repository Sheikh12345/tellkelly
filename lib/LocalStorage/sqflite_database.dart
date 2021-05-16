import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase{
  static final _dbName = "User${FirebaseAuth.instance.currentUser.uid}";
  static final _dbVersion = 1;
  static final tableName = "BestStories";
  static final columnId = "_id";
  static final storyName = "storyName";
  static final storyBody = "storyBody";
  static final storyImageUrl = "storyImageUrl";



  LocalDatabase._privateConstructor();

  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  /// Database creating function ///
static Database _database;

Future<Database> get database async{
  if(_database!=null) return _database;

  _database = await _initiateDatabase();
  return _database;
}


  _initiateDatabase()async{
  Directory directory = await getApplicationDocumentsDirectory();

  /// we need path package to use join function
  String path = join(directory.path,_dbName);

  return await openDatabase(path,version: _dbVersion,onCreate: _onCreate);
  }

  Future<int> _onCreate(Database db,int version){
  db.execute(
    '''
    CREATE TABLE $tableName(
    $columnId INTEGER PRIMARY KEY,
    $storyName TEXT NOT NULL,
    $storyBody TEXT NOT NULL,
    $storyImageUrl TEXT NOT NULL
    )
    '''
  );
  }


 /// CRUD Operations ///


  /// Insert data
Future<int> insert(Map<String,dynamic> row)async{
try{
  Database db = await instance.database;
  return await db.insert(tableName, row);
}catch(e){

}
}

/// Read all stories
Future<List<Map<String,dynamic>>> readAll()async{
try{
  Database db = await instance.database;

  return await db.query(tableName);
}catch(e){

}
}


  /// Read all stories
  Future<List<Map<String,dynamic>>> readOne(String storyTitle)async{
 try{
   Database db = await instance.database;

   return await db.rawQuery('SELECT * FROM $tableName WHERE $storyName = ?', [storyTitle]);

 }catch(e){

 }
  }


/// Delete selected story
Future<int>  delete(String storyTitle)async{
try{
  Database db = await instance.database;
  return await db.delete(tableName,where: '$storyName = ?' ,whereArgs: [storyTitle]);

}catch(e){

}
}



}




