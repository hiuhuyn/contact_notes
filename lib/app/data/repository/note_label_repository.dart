import 'dart:developer';

import 'package:contact_notes/app/data/data_sources/local/note_label_database.dart';
import 'package:contact_notes/app/data/data_sources/local/people_note_database.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';

import 'package:contact_notes/core/state/data_sate.dart';

import '../../domain/repository/note_label_repository.dart';

class NoteLabelRepositoryIml implements NoteLabelRepository {
  NoteLabelDatabase noteLabelDatabase;
  PeopleNoteDatabase peopleNoteDatabase;
  NoteLabelRepositoryIml(this.noteLabelDatabase, this.peopleNoteDatabase);
  @override
  Future<DataState<NoteLabel>> createNoteLabel(NoteLabel noteLabel) async {
    try {
      noteLabel.id = await noteLabelDatabase.insert(noteLabel);
      return DataSuccess(noteLabel);
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Create note label error: $e"));
    }
  }

  @override
  Future<DataState<NoteLabel>> updateNoteLabel(NoteLabel noteLabel) async {
    try {
      await noteLabelDatabase.update(noteLabel);
      return DataSuccess(noteLabel);
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Create note label error: $e"));
    }
  }

  @override
  Future<DataState> deleteNoteLabel(int id) async {
    try {
      await noteLabelDatabase.delete<int>(id);
      await peopleNoteDatabase.queryByIdLabel(id).then(
        (value) async {
          if (value != null) {
            for (int i = 0; i < value.length; i++) {
              value[i].idLabel = null;
              await peopleNoteDatabase.update(value[i]);
            }
          }
        },
      );
      return const DataSuccess(());
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Delete note label error: $e"));
    }
  }

  @override
  Future<DataState<List<NoteLabel>>> getAllNoteLabels() async {
    try {
      List<NoteLabel> res = await noteLabelDatabase.queryAllRows();
      return DataSuccess(res);
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Get all note label error: $e"));
    }
  }

  @override
  Future<DataState<NoteLabel>> getNoteLabelById(int id) async {
    try {
      NoteLabel? res = await noteLabelDatabase.queryById(id);
      if (res != null) {
        return DataSuccess(res);
      } else {
        return DataFailed(
            CustomException("Don't have a note label with the given id."));
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Get all note label error: $e"));
    }
  }

  @override
  Future<DataState> deleteAll() async {
    try {
      noteLabelDatabase.deleteAllRow();
      return const DataSuccess(());
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }
}
