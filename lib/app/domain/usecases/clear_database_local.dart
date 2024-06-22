// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:contact_notes/app/data/data_sources/local/file_service.dart';
import 'package:contact_notes/app/domain/repository/note_label_repository.dart';
import 'package:contact_notes/app/domain/repository/people_note_repository.dart';
import 'package:contact_notes/app/domain/repository/relationship_repository.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class ClearDatabaseLocal extends UsecaseNoVariable<DataState> {
  PeopleNoteRepository peopleNoteRepository;
  NoteLabelRepository noteLabelRepository;
  RelationshipRepository relationshipRepository;
  FileService fileService;

  ClearDatabaseLocal(
    this.peopleNoteRepository,
    this.noteLabelRepository,
    this.relationshipRepository,
    this.fileService,
  );
  @override
  Future<DataState> call() async {
    final peopleDelete = await peopleNoteRepository.deleteAll();
    if (peopleDelete is DataFailed) {
      return peopleDelete;
    }
    final noteDelete = await noteLabelRepository.deleteAll();
    if (noteDelete is DataFailed) {
      return noteDelete;
    }
    final relationshipDelete = await relationshipRepository.deleteAll();
    if (relationshipDelete is DataFailed) {
      return relationshipDelete;
    }
    try {
      await fileService.deleteDirectory();
    } catch (e) {
      return DataFailed(CustomException(e.toString()));
    }
    return const DataSuccess(());
  }
}
