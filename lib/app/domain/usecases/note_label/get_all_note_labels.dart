import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/repository/note_label_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';

import '../../../../core/utils/usecase.dart';

class GetAllNoteLabels
    extends UsecaseOneVariable<DataState<List<NoteLabel>>, void> {
  NoteLabelRepository repository;
  GetAllNoteLabels(this.repository);

  @override
  Future<DataState<List<NoteLabel>>> call(void value) async {
    return await repository.getAllNoteLabels();
  }
}
