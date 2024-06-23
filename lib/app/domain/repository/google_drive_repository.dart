import 'package:contact_notes/core/state/data_sate.dart';
import 'package:googleapis/drive/v3.dart' as drive;

abstract class GoogleDriveRepository {
  final databaseAppJson = "database_app.json";
  final peopleNoteAppFolder = "people_note_app";
  final folderImageName = "images";

  final keyNoteLabel = "note_label";
  final keyPeopleNote = "people_note";
  final keyRelationship = "relationship";
  Future<DataState> restoreFromGoogleDrive();
  Future<DataState> cleanFolderGoogleDrive();
  Future<DataState> backupToGoogleDrive();
  Future<DataState<drive.File>> getMostRecentlyModifiedFile();
}
