import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/repository/people_note_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class CreatePeopleNote
    extends UsecaseOneVariable<DataState<PeopleNote>, PeopleNote> {
  PeopleNoteRepository repository;
  CreatePeopleNote(this.repository);

  @override
  Future<DataState<PeopleNote>> call(PeopleNote value) async {
    return await repository.createPeopleNote(value);
  }
}
