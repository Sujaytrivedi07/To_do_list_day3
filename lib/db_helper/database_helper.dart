import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';


class DataBaseHelper{

  static const dbname="mydata.db";
  static const dbversion=1;
  static const dbtable="mytable";
  static const columnid="id";
  static const columntitle="title";
  static const columnDescription="description";

  static final DataBaseHelper instance=DataBaseHelper();//constructor

  static Database? _database;                  //check database is null or not
  Future<Database?> get database async{          // if null then create it
    if(_database !=null){
      return _database;
    }
    _database =await initDataBase();
    return _database;
  }

  initDataBase() async{
    // create database
    io.Directory documentDirectory = await  getApplicationDocumentsDirectory();
    String path=join(documentDirectory.path,dbname);
    var db=await openDatabase(path,version: dbversion,onCreate: _onCreate);
    return db;
  }


  _onCreate(Database db,int version)async{
    await db.execute("CREATE TABLE $dbtable ($columnid INTEGER PRIMARY KEY AUTOINCREMENT,$columntitle TEXT NOT NULL,$columnDescription TEXT NOT NULL)");
    //  await db.execute("CREATE TABLE GroupThird (id INTEGER PRIMARY KEY AUTOINCREMENT,message TEXT NOT NULL");
  }

  insertrecord(Map<String,dynamic> row) async{
    //for inserting entries
      Database? db =await instance.database;
      return await db?.insert(dbtable, row);
  }
  Future<List<Map<String,dynamic>>> queryDatabase()async{
    Database? db =await instance.database;
      return await db!.query(dbtable);
  }

Future<int>update(Map<String,dynamic> row) async {
  Database? db =await instance.database;
  int id=row[columnid];
  return await db!.update(dbtable, row,where:"$columnid=?",whereArgs: [id]);
}

 Future<int>deleterecord(int id)async{
    Database? db=await instance.database;
    return await db!.delete(dbtable,where: '$columnid=?',whereArgs: [id]);
 }


}