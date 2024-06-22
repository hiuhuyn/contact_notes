import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:contact_notes/app/data/data_sources/local/app_sqlite.dart';
import 'package:contact_notes/app/data/models/people_note.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';

class PeopleNoteDatabase extends AppSqlite<PeopleNote> {
  PeopleNoteDatabase({super.fileName})
      : super(tableName: AppSqlite.peopleNoteTableName);

  @override
  Future<List<PeopleNote>> queryAllRows() async {
    isCheckUser();
    if (db != null) {
      List<Map<String, Object?>> maps = await db!.query(tableName,
          where: "author = ?",
          whereArgs: [FirebaseAuth.instance.currentUser?.uid]);
      final list = <PeopleNote>[];
      for (var element in maps) {
        try {
          list.add(PeopleNoteModel.fromMap(element).copyWith());
        } catch (e) {
          log("Error format data: $e");
        }
      }
      return list;
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<PeopleNote?> queryById<String>(String id) async {
    isCheckUser();
    if (db != null) {
      final maps = await db!
          .query(tableName, where: 'id = ?', whereArgs: [id], limit: 1);

      if (maps.isNotEmpty) {
        return PeopleNoteModel.fromMap(maps.first).copyWith();
      } else {
        return null; // Không tìm thấy
      }
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<List<PeopleNote>?> queryByKeyWork(String keywork) async {
    isCheckUser();
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db!.query(
        tableName,
        where: 'name like ?',
        whereArgs: ['%$keywork%'],
      );

      if (maps.isNotEmpty) {
        final list = <PeopleNote>[];
        for (var element in maps) {
          try {
            list.add(PeopleNoteModel.fromMap(element).copyWith());
          } catch (e) {
            log("Error format data: $e");
          }
        }
        return list;
      } else {
        return null; // Không tìm thấy
      }
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  Future<List<PeopleNote>?> queryByIdLabel(String idLabel) async {
    isCheckUser();
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db!.query(
        tableName,
        where: 'idLabel = ?',
        whereArgs: [idLabel],
      );

      if (maps.isNotEmpty) {
        final list = <PeopleNote>[];
        for (var element in maps) {
          try {
            list.add(PeopleNoteModel.fromMap(element).copyWith());
          } catch (e) {
            log("Error format data: $e");
          }
        }
        return list;
      } else {
        return null;
      }
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  Future<List<PeopleNote>?> queryByLabelAndName(
      String idLabel, String name) async {
    if (db != null) {
      isCheckUser();
      final List<Map<String, dynamic>> maps = await db!.query(
        tableName,
        where: 'idLabel = ? and name like ?',
        whereArgs: [idLabel, "%$name%"],
      );

      if (maps.isNotEmpty) {
        final list = <PeopleNote>[];
        for (var element in maps) {
          try {
            list.add(PeopleNoteModel.fromMap(element).copyWith());
          } catch (e) {
            log("Error format data: $e");
          }
        }
        return list;
      } else {
        return null;
      }
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<int> update(PeopleNote value) async {
    isCheckUser();
    value.updated = DateTime.now();
    if (db != null) {
      return await db!.update(
          tableName, PeopleNoteModel.fromEntity(value).toMap(),
          where: "id = ?", whereArgs: [value.id]);
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<int> insert(PeopleNote value) async {
    isCheckUser();
    if (db != null) {
      final existingRecord = await db!.query(
        tableName,
        where: 'id = ?',
        whereArgs: [value.id],
      );

      if (existingRecord.isNotEmpty) {
        throw CustomException("Record with ID ${value.id} already exists",
            errorType: ErrorType.database);
      }

      return await db!
          .insert(tableName, PeopleNoteModel.fromEntity(value).toMap());
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }
}
