import 'package:contact_notes/app/domain/entity/relationship.dart';
import 'package:contact_notes/app/domain/repository/relationship_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class GetRelationshipsByPersonId
    extends UsecaseOneVariable<DataState<List<Relationship>>, int> {
  final RelationshipRepository _repository;
  GetRelationshipsByPersonId(this._repository);
  @override
  Future<DataState<List<Relationship>>> call(int value) async {
    return _repository.getByIdPerson(value);
  }
}
