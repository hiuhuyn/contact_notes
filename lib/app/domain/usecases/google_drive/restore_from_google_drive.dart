import 'package:contact_notes/app/domain/repository/google_drive_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class RestoreFromGoogleDrive extends UsecaseNoVariable<DataState> {
  final GoogleDriveRepository _googleDriveRepository;
  RestoreFromGoogleDrive(this._googleDriveRepository);
  @override
  Future<DataState> call() async {
    return await _googleDriveRepository.restoreFromGoogleDrive();
  }
}
