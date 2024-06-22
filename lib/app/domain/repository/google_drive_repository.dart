import 'package:contact_notes/core/state/data_sate.dart';

abstract class GoogleDriveRepository {
  Future<DataState> getDataFromGoogleDrive();
  Future<DataState> cleanFolderGoogleDrive();
  Future<DataState> backupToGoogleDrive();
}
