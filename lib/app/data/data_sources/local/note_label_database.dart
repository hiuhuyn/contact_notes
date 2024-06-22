import 'package:contact_notes/app/data/models/note_label.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/data/data_sources/local/app_sqlite.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';

class NoteLabelDatabase extends AppSqlite<NoteLabel> {
  NoteLabelDatabase({super.fileName})
      : super(tableName: AppSqlite.noteLabelTableName);

  @override
  Future<int> update(NoteLabel value) async {
    isCheckUser();
    if (db != null) {
      return await db!.update(
          tableName, NoteLabelModel.fromEntity(value).toMap(),
          where: "id = ?", whereArgs: [value.id]);
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<List<NoteLabel>> queryAllRows() async {
    isCheckUser();
    if (db != null) {
      List<Map<String, Object?>> maps = await db!.query(tableName);
      return maps.map((e) => NoteLabelModel.fromMap(e).toEntity()).toList();
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<NoteLabel?> queryById<String>(String id) async {
    isCheckUser();
    if (db != null) {
      final maps = await db!
          .query(tableName, where: 'id = ?', whereArgs: [id], limit: 1);

      if (maps.isNotEmpty) {
        return NoteLabelModel.fromMap(maps.first).toEntity();
      } else {
        return null; // Không tìm thấy
      }
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }

  @override
  Future<List<NoteLabel>?> queryByKeyWork(String keywork) async {
    isCheckUser();
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db!.query(
        tableName,
        where: 'id = ?',
        whereArgs: [keywork],
      );

      if (maps.isNotEmpty) {
        return maps
            .map(
              (e) => NoteLabelModel.fromMap(e).toEntity(),
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
  Future<int> insert(NoteLabel value) async {
    isCheckUser();
    if (db != null) {
      return await db!
          .insert(tableName, NoteLabelModel.fromEntity(value).toMap());
    } else {
      throw CustomException("db is not available",
          errorType: ErrorType.database);
    }
  }
}
