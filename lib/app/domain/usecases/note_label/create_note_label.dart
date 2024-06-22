import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/repository/note_label_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class CreateNoteLabel
    extends UsecaseOneVariable<DataState<NoteLabel>, NoteLabel> {
  NoteLabelRepository repository;
  CreateNoteLabel(this.repository);
  @override
  Future<DataState<NoteLabel>> call(NoteLabel value) async {
    return await repository.createNoteLabel(value);
  }
}
