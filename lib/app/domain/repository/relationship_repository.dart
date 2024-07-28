import 'package:contact_notes/app/domain/entity/relationship.dart';
import 'package:contact_notes/core/state/data_sate.dart';

abstract class RelationshipRepository {
  Future<DataState<List<Relationship>>> getAll();
  Future<DataState<Relationship>> getById(int id);
  Future<DataState<List<Relationship>>> getByIdPerson(int idPerson);
  Future<DataState<Relationship>> create(Relationship value);
  Future<DataState> update(Relationship value);
  Future<DataState> delete(int id);
  Future<DataState> deleteAll();
}
