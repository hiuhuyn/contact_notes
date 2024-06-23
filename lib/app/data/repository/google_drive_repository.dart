import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:contact_notes/app/data/data_sources/local/file_service.dart';
import 'package:contact_notes/app/data/data_sources/local/note_label_database.dart';
import 'package:contact_notes/app/data/data_sources/local/people_note_database.dart';
import 'package:contact_notes/app/data/data_sources/local/relationship_database.dart';
import 'package:contact_notes/app/data/models/note_label.dart';
import 'package:contact_notes/app/data/models/people_note.dart';
import 'package:contact_notes/app/data/models/relationship.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/mime_type.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../domain/repository/google_drive_repository.dart';
import '../data_sources/remote/google_driver_service.dart';

class GoogleDriveRepositoryIml extends GoogleDriveRepository {
  final FileService _fileService;
  final GoogleDriveService _googleDriveService;
  final NoteLabelDatabase _noteLabelDatabase;
  final PeopleNoteDatabase _peopleNoteDatabase;
  final RelationshipDatabase _relationshipDatabase;

  GoogleDriveRepositoryIml(
      this._fileService,
      this._googleDriveService,
      this._noteLabelDatabase,
      this._peopleNoteDatabase,
      this._relationshipDatabase);

  @override
  Future<DataState> backupToGoogleDrive() async {
    try {
      final noteLableAll = await _noteLabelDatabase.queryAllRows();
      final peopleNoteAll = await _peopleNoteDatabase.queryAllRows();
      final relationshipAll = await _relationshipDatabase.queryAllRows();

      Uint8List jsonData = Uint8List.fromList(
        utf8.encode(
          jsonEncode(
            {
              keyNoteLabel: noteLableAll
                  .map(
                    (e) => NoteLabelModel.fromEntity(e).toMap(),
                  )
                  .toList(),
              keyPeopleNote: peopleNoteAll
                  .map(
                    (e) => PeopleNoteModel.fromEntity(e).toMapBackup(),
                  )
                  .toList(),
              keyRelationship: relationshipAll
                  .map(
                    (e) => RelationshipModel.fromEntity(e).toMap(),
                  )
                  .toList(),
            },
          ),
        ),
      );
      final driveApi = await _googleDriveService.getDriveApi();
      String? idFolderApp = await _googleDriveService
          .createFolder(peopleNoteAppFolder, driveApi: driveApi);
      if (idFolderApp == null) throw Exception("id folder app is null");

      String? idFolderAppDateNow = await _googleDriveService.createFolder(
          DateTime.now().toString(),
          idFolderParents: idFolderApp,
          driveApi: driveApi);
      if (idFolderAppDateNow == null) {
        throw Exception("it not create new folder save data in google drive");
      }

      await _googleDriveService.saveFileToFolder(idFolderAppDateNow,
          databaseAppJson, jsonData, MimeTypes.applicationJson,
          driveApi: driveApi);

      String? idFolderSaveImage = await _googleDriveService.createFolder(
          folderImageName,
          idFolderParents: idFolderAppDateNow,
          driveApi: driveApi);
      if (idFolderSaveImage == null) {
        throw Exception("it not create new folder save image in google drive");
      }

      final fileImages = await _fileService.getFileInFolderImages();
      for (var file in fileImages) {
        final fileName = path.basename(file.path);
        String extension = fileName.split('.').last.toLowerCase();
        String mimeType = "image/$extension";

        List<int> bytes = await file.readAsBytes();
        Uint8List uint8List = Uint8List.fromList(bytes);
        await _googleDriveService.saveFileToFolder(
            idFolderSaveImage, fileName, uint8List, mimeType,
            driveApi: driveApi);
      }

      return const DataSuccess(());
    } catch (e) {
      log(e.toString());
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState> cleanFolderGoogleDrive() async {
    try {
      final driveApi = await _googleDriveService.getDriveApi();

      String? idFolderApp = await _googleDriveService
          .getIdFileByName(peopleNoteAppFolder, driveApi: driveApi);
      if (idFolderApp == null) {
        return DataFailed(CustomException("You don't have a data backup!",
            errorType: ErrorType.continuable));
      }
      await _googleDriveService.deleteAllFilesInFolder(idFolderApp,
          driveApi: driveApi);
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
    return const DataSuccess(());
  }

  @override
  Future<DataState> restoreFromGoogleDrive() async {
    try {
      final driveApi = await _googleDriveService.getDriveApi();

      String? idFolderApp = await _googleDriveService
          .getIdFileByName(peopleNoteAppFolder, driveApi: driveApi);
      if (idFolderApp == null) {
        return DataFailed(CustomException("You don't have a data backup!",
            errorType: ErrorType.continuable));
      }
      final fileBackupNearest = await _googleDriveService
          .getMostRecentlyModifiedFile(idFolderApp, driveApi: driveApi);
      if (fileBackupNearest == null) {
        return DataFailed(CustomException("You don't have a data backup!",
            errorType: ErrorType.continuable));
      }
      log("get id file data json");
      final idFileDataJson = await _googleDriveService.getIdFileByName(
          databaseAppJson,
          driveApi: driveApi,
          idFolderParents: fileBackupNearest.id);
      log("get id file data json: $idFileDataJson");

      if (idFileDataJson == null) {
        return DataFailed(CustomException("You don't have a data backup!",
            errorType: ErrorType.continuable));
      }
      final fileDataJson = await _googleDriveService
          .downloadFile(idFileDataJson, driveApi: driveApi);
      if (fileDataJson == null) {
        return DataFailed(CustomException("You don't have a data backup!",
            errorType: ErrorType.continuable));
      }
      final jsonData = jsonDecode(utf8.decode(fileDataJson));
      final noteLableJson = jsonData[keyNoteLabel];
      final peopleNoteJson = jsonData[keyPeopleNote];
      final relationshipJson = jsonData[keyRelationship];

      if (noteLableJson != null) {
        for (var e in noteLableJson) {
          await _noteLabelDatabase.insert(NoteLabelModel.fromMap(e));
        }
      }

      if (relationshipJson != null) {
        for (var e in relationshipJson) {
          await _relationshipDatabase.insert(RelationshipModel.fromMap(e));
        }
      }

      Directory appDocDir = await getApplicationDocumentsDirectory();
      final directoryPath = '${appDocDir.path}/images';

      if (peopleNoteJson != null) {
        for (var e in peopleNoteJson) {
          PeopleNoteModel people = PeopleNoteModel.fromMap(e);
          if (people.photos != null) {
            for (int i = 0; i < people.photos!.length; i++) {
              people.photos![i] = "$directoryPath/${people.photos![i]}";
            }
          }
          try {
            await _peopleNoteDatabase.insert(people.copyWith());
          } catch (e) {
            log(e.toString());
          }
        }
      }

      final idFolderImage = await _googleDriveService.getIdFileByName(
          folderImageName,
          driveApi: driveApi,
          idFolderParents: fileBackupNearest.id);

      if (idFolderImage != null) {
        final listIdFileImage = await _googleDriveService
            .listFilesInFolder(idFolderImage, driveApi: driveApi);
        for (var e in listIdFileImage) {
          final dataImg =
              await _googleDriveService.downloadFile(e.id!, driveApi: driveApi);
          if (dataImg != null && e.name != null) {
            await _fileService.saveFileImageToAppDirectory(e.name!, dataImg);
          }
        }
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
    return const DataSuccess(());
  }

  @override
  Future<DataState<drive.File>> getMostRecentlyModifiedFile() async {
    try {
      final driveApi = await _googleDriveService.getDriveApi();
      String? idFolderApp = await _googleDriveService
          .getIdFileByName(peopleNoteAppFolder, driveApi: driveApi);
      if (idFolderApp == null) {
        return DataFailed(CustomException("You don't have a data backup!",
            errorType: ErrorType.continuable));
      }
      final fileMost = await _googleDriveService
          .getMostRecentlyModifiedFile(idFolderApp, driveApi: driveApi);
      if (fileMost == null) {
        return DataFailed(CustomException("You don't have a data backup!",
            errorType: ErrorType.continuable));
      }
      return DataSuccess(fileMost);
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }
}
