import 'package:contact_notes/app/domain/repository/google_drive_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class CleanFolderGoogleDrive extends UsecaseNoVariable<DataState> {
  final GoogleDriveRepository _googleDriveRepository;
  CleanFolderGoogleDrive(this._googleDriveRepository);
  @override
  Future<DataState> call() async {
    return await _googleDriveRepository.cleanFolderGoogleDrive();
  }
}
