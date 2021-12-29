import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pass_protect/model/passwordclass.dart';

import 'dart:io';
import 'dart:async';

class DBProvider{
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;


  Future<Database> get database async{
    if(_database != null)
      return _database;

    _database = await initializeDB();
    return _database;
  }

   initializeDB() async{
     Directory documentDirectory = await getApplicationDocumentsDirectory();
     String path = join(documentDirectory.path, 'TestDb.db');
     return await openDatabase(path, version: 1, onCreate: (Database db, int version) async{
       await db.execute(
           "CREATE TABLE Passwords ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT,"
               "app_name TEXT,"
               "icon TEXT,"
               "color TEXT,"
               "password TEXT,"
               "user_name TEXT"
               ")"
       );
     });
  }

  newPassword(Password password) async{
    final db = _database;
    var result = await db.insert('Passwords', password.toJson());
    return result;
  }
  
  getPassword(int id) async{
    final db = _database;
    var result = await db.query('Passwords',where: "id = ?",whereArgs: [id]);
    return result.isNotEmpty ? Password.fromJson(result.first) : Null;
  }

  getAllPassword() async{
    if(_database == null)
      _database = await initializeDB();
    final db = _database;
    var result = await db.query('Passwords');
    List<Password> resultList = result.isNotEmpty ? result.map((e) => Password.fromJson(e)).toList() : [];
    return resultList;
  }

  updatePassword(Password newPassword) async{
    final db = await _database;
    var result = await db.update('Passwords', newPassword.toJson(),
    where: "id = ?",whereArgs: [newPassword.id]);
    return result;
  }

  deletePassword(int id) async{
    final db = await _database;
    db.delete('Passwords',where: "id = ?",whereArgs: [id]);
  }

  deleteAllPassword() async{
    final db = await _database;
    await db.delete('Passwords');
  }
}