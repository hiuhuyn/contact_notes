import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/repository/note_label_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class GetNoteLabelById
    extends UsecaseOneVariable<DataState<NoteLabel>, int> {
  NoteLabelRepository repository;
  GetNoteLabelById(this.repository);
  @override
  Future<DataState<NoteLabel>> call(int value) async {
    return await repository.getNoteLabelById(value);
  }
}
