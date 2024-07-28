import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/core/state/data_sate.dart';

abstract class NoteLabelRepository {
  Future<DataState<List<NoteLabel>>> getAllNoteLabels();
  Future<DataState<NoteLabel>> getNoteLabelById(int id);
  Future<DataState<NoteLabel>> createNoteLabel(NoteLabel noteLabel);
  Future<DataState<NoteLabel>> updateNoteLabel(NoteLabel noteLabel);
  Future<DataState> deleteNoteLabel(int id);
  Future<DataState> deleteAll();
}
