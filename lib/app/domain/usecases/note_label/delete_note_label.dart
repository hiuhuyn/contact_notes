import 'package:contact_notes/app/domain/repository/note_label_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class DeleteNoteLabel extends UsecaseOneVariable<DataState, String> {
  NoteLabelRepository repository;
  DeleteNoteLabel(this.repository);
  @override
  Future<DataState> call(String value) async {
    return await repository.deleteNoteLabel(value);
  }
}
