import 'package:contact_notes/app/domain/repository/google_drive_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class BackupToGoogleDrive extends UsecaseNoVariable<DataState> {
  final GoogleDriveRepository _googleDriveRepository;
  BackupToGoogleDrive(this._googleDriveRepository);
  @override
  Future<DataState> call() async {
    return await _googleDriveRepository.backupToGoogleDrive();
  }
}
