import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/repository/people_note_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class GetAllPeopleNotes
    extends UsecaseOneVariable<DataState<List<PeopleNote>>, dynamic> {
  PeopleNoteRepository repository;
  GetAllPeopleNotes(this.repository);

  @override
  Future<DataState<List<PeopleNote>>> call(value) async {
    return await repository.getAllPeopleNotes();
  }
}
