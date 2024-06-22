import 'package:contact_notes/app/domain/entity/relationship.dart';
import 'package:contact_notes/app/domain/repository/relationship_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class UpdateRelationship extends UsecaseOneVariable<DataState, Relationship> {
  final RelationshipRepository _repository;
  UpdateRelationship(this._repository);
  @override
  Future<DataState> call(Relationship value) async {
    return await _repository.update(value);
  }
}
