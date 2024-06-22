import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/exceptions/custom_exception.dart';

abstract class AppSqlite<T> {
  Database? db;
  late final String fileName;
  late final String tableName;
  static const String peopleNoteTableName = "people_note";
  static const String noteLabelTableName = "note_label";
  static const String relationshipTableName = "relationship";

  AppSqlite({String? fileName, required this.tableName}) {
    fileName != null
        ? this.fileName = fileName
        : this.fileName = "people_notes.db";
  }
  Future initDatabase() async {
    String path = join(await getDatabasesPath(), fileName);
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  static Future deleteDB(String fileName) async {
    String path = join(await getDatabasesPath(), fileName);
    await deleteDatabase(path);
  }

  Future _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $noteLabelTableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        color INTEGER
      )''');
    await db.execute('''
            CREATE TABLE $peopleNoteTableName (
              id TEXT PRIMARY KEY,
              desc TEXT,
              idLabel TEXT,
              created TEXT,
              updated TEXT,
              photos TEXT,
              author TEXT,
              name TEXT,
              phoneNumber TEXT,
              address TEXT,
              isMale INTEGER,
              relationships TEXT,
              latitude REAL,
              longitude REAL,
              birthday TEXT,
              country TEXT,
              maritalStatus TEXT,
              occupation TEXT
          )''');
    await db.execute('''
          CREATE TABLE $relationshipTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idPerson1 TEXT,
            idPerson2 TEXT,
            description TEXT
          )
        ''');
  }

  bool isCheckUser() {
    if (FirebaseAuth.instance.currentUser == null) {
      throw CustomException("You need to log in to use this feature",
          errorType: ErrorType.authentication);
    }
    return true;
  }

  Future<int> insert(T value);

  Future<int> update(T value);
  Future delete<E>(E id) async {
    await db!.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<List<T>> queryAllRows();
  Future<T?> queryById<E>(E id);
  Future<List<T>?> queryByKeyWork(String keywork);

  Future deleteAllRow() async {
    if (db == null) {
      throw CustomException("Database is not initialized",
          errorType: ErrorType.database);
    }
    try {
      await db?.delete(tableName);
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      await db?.delete(tableName);
    }
  }
}
