import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/repository/people_note_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class GetPeopleNotesByLabelAndName
    extends UsecaseTwoVariable<DataState<List<PeopleNote>>, int, String> {
  PeopleNoteRepository repository;
  GetPeopleNotesByLabelAndName(this.repository);

  @override
  Future<DataState<List<PeopleNote>>> call(int idLabel, String name) async {
    return await repository.getPeopleNoteByLabelAndName(idLabel, name);
  }
}
