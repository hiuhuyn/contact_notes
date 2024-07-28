import 'package:contact_notes/app/data/data_sources/local/app_sqlite.dart';
import 'package:contact_notes/app/data/models/relationship.dart';
import 'package:contact_notes/app/domain/entity/relationship.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:sqflite/sqflite.dart';

class RelationshipDatabase extends AppSqlite<Relationship> {
  RelationshipDatabase({super.fileName})
      : super(tableName: AppSqlite.relationshipTableName);

  @override
  Future<List<Relationship>> queryAllRows() async {
    if (db != null) {
      List<Map<String, Object?>> maps = await db!.query(tableName);
      return maps.map((e) => RelationshipModel.fromMap(e).toEntity()).toList();
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<Relationship?> queryById<int>(int id) async {
    if (db != null) {
      final maps = await db!.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return RelationshipModel.fromMap(maps.first).toEntity();
      } else {
        return null; // Không tìm thấy
      }
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<List<Relationship>?> queryByKeyWork<int>(int idPerson) async {
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db!.query(
        tableName,
        where: 'idPerson1 = ? or  idPerson2 = ?',
        whereArgs: [idPerson, idPerson],
      );

      if (maps.isNotEmpty) {
        return maps
            .map(
              (e) => RelationshipModel.fromMap(e).toEntity(),
            )
            .toList();
      } else {
        return null; // Không tìm thấy
      }
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<int> update(Relationship value) async {
    if (db != null) {
      return await db!.update(
          tableName, RelationshipModel.fromEntity(value).toMap(),
          where: "id = ?", whereArgs: [value.id]);
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  Future<bool> checkExistence(int idPerson1, int idPerson2) async {
    final result = await db?.rawQuery(
      'SELECT COUNT(*) FROM $tableName WHERE (idPerson1 = ? AND idPerson2 = ?) OR (idPerson1 = ? AND idPerson2 = ?)',
      [idPerson1, idPerson2, idPerson2, idPerson1],
    );
    if (result == null) return false;
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  @override
  Future<int> insert(Relationship value) async {
    if (db != null &&
        value.idPerson1 != null &&
        value.idPerson2 != null &&
        value.id == null) {
      final check = await checkExistence(value.idPerson1!, value.idPerson2!);
      if (check) {
        if (value.description != null) {
          await update(value);
        }
        throw CustomException("Relationship already exists",
            errorType: ErrorType.continuable);
      }
      return await db!
          .insert(tableName, RelationshipModel.fromEntity(value).toMap());
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }
}
