import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/repository/people_note_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class GetPeopleNoteById
    extends UsecaseOneVariable<DataState<PeopleNote>, String> {
  PeopleNoteRepository repository;
  GetPeopleNoteById(this.repository);

  @override
  Future<DataState<PeopleNote>> call(String value) async {
    return await repository.getPeopleNoteById(value);
  }
}
