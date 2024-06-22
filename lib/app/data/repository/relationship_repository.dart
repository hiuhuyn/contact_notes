import 'package:contact_notes/app/data/data_sources/local/relationship_database.dart';
import 'package:contact_notes/app/data/models/relationship.dart';
import 'package:contact_notes/app/domain/entity/relationship.dart';
import 'package:contact_notes/app/domain/repository/relationship_repository.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';

class RelationshipRepositoryIml extends RelationshipRepository {
  RelationshipDatabase relationshipDatabaseLocal;
  RelationshipRepositoryIml(this.relationshipDatabaseLocal);
  @override
  Future<DataState<Relationship>> create(Relationship value) async {
    try {
      final result = await relationshipDatabaseLocal.insert(value);
      return DataSuccess(
          RelationshipModel.fromEntity(value).copyWith(id: result));
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState> delete(int id) async {
    try {
      await relationshipDatabaseLocal.delete<int>(id);
      return const DataSuccess(());
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState<List<Relationship>>> getAll() async {
    try {
      final result = await relationshipDatabaseLocal.queryAllRows();
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState<Relationship>> getById(int id) async {
    try {
      final result = await relationshipDatabaseLocal.queryById(id);
      if (result != null) {
        return DataSuccess(result);
      }
      return DataFailed(
          CustomException("Data not found", errorType: ErrorType.continuable));
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState<List<Relationship>>> getByIdPerson(String idPerson) async {
    try {
      final result = await relationshipDatabaseLocal.queryByKeyWork(idPerson);
      if (result != null) {
        return DataSuccess(result);
      }
      return DataFailed(
          CustomException("Data not found", errorType: ErrorType.continuable));
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState> update(Relationship value) async {
    try {
      await relationshipDatabaseLocal.update(value);
      return const DataSuccess(());
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState> deleteAll() async {
    try {
      relationshipDatabaseLocal.deleteAllRow();
      return const DataSuccess(());
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }
}
