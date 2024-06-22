import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/core/state/data_sate.dart';

abstract class PeopleNoteRepository {
  Future<DataState<List<PeopleNote>>> getAllPeopleNotes();
  Future<DataState<PeopleNote>> createPeopleNote(PeopleNote value);
  Future<DataState<PeopleNote>> updatePeopleNote(PeopleNote value);
  Future<DataState> deletePeopleNote(PeopleNote value);
  Future<DataState<List<PeopleNote>>> getPeopleNoteByLabel(String idLabel);
  Future<DataState<PeopleNote>> getPeopleNoteById(String id);
  Future<DataState<List<PeopleNote>>> getPeopleNoteByName(String name);
  Future<DataState<List<PeopleNote>>> getPeopleNoteByLabelAndName(
      String idLabel, String name);
  Future<DataState> deleteAll();
}
