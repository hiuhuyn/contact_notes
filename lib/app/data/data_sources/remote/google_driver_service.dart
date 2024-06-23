import 'dart:developer';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../../../../core/exceptions/custom_exception.dart';
import 'firebase_service.dart';

class GoogleDriveService {
  final FirebaseService _firebaseService;

  GoogleDriveService(this._firebaseService);

  Future<drive.DriveApi> getDriveApi() async {
    final GoogleSignInAuthentication? googleAuth =
        await _firebaseService.getGoogleAuth();

    if (googleAuth == null) {
      throw Exception("User is not signed in");
    }

    final authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken('Bearer', googleAuth.accessToken!,
            DateTime.now().toUtc().add(Duration(hours: 1))),
        googleAuth.idToken,
        ['https://www.googleapis.com/auth/drive.file'],
      ),
    );

    return drive.DriveApi(authClient);
  }

  Future<String?> createFolder(String folderName,
      {String? idFolderParents, drive.DriveApi? driveApi}) async {
    try {
      driveApi ??= await getDriveApi();

      final existingFolder = await driveApi.files.list(
        q: "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false${idFolderParents != null ? " and '$idFolderParents' in parents" : ""}",
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      if (existingFolder.files != null && existingFolder.files!.isNotEmpty) {
        log('Folder already exists: ${existingFolder.files!.first.id}');
        return existingFolder.files!.first.id;
      }

      final drive.File folder = drive.File();
      folder.name = folderName;
      folder.mimeType = 'application/vnd.google-apps.folder';
      if (idFolderParents != null) folder.parents = [idFolderParents];

      final createdFolder = await driveApi.files.create(folder);
      log('Folder created: ${createdFolder.id}');
      return createdFolder.id;
    } catch (e) {
      log('Error creating folder: $e');
      throw CustomException('Error creating folder: $e');
    }
  }

  Future<void> saveFileToFolder(
      String folderId, String fileName, Uint8List fileData, String mimeType,
      {drive.DriveApi? driveApi}) async {
    try {
      driveApi ??= await getDriveApi();

      final drive.File file = drive.File();
      file.name = fileName;
      file.parents = [folderId];
      file.mimeType = mimeType;

      final media = drive.Media(Stream.value(fileData), fileData.length);

      final createdFile = await driveApi.files.create(file, uploadMedia: media);
      log('File created: ${createdFile.id}');
    } catch (e) {
      log('Error saving file: $e');
    }
  }

  Future<List<drive.File>> listFilesInFolder(String folderId,
      {drive.DriveApi? driveApi}) async {
    try {
      driveApi ??= await getDriveApi();
      final fileList = await driveApi.files.list(
        q: "'$folderId' in parents",
        spaces: 'drive',
        $fields: 'files(id, name, mimeType)',
      );
      log("${fileList.files?.toList().toString()}");
      return fileList.files ?? [];
    } catch (e) {
      log('Error listing files: $e');
      return [];
    }
  }

  Future<drive.File?> getMostRecentlyModifiedFile(String folderId,
      {drive.DriveApi? driveApi}) async {
    try {
      driveApi ??= await getDriveApi();

      // Truy vấn các tệp trong thư mục cha và sắp xếp theo ngày sửa đổi cuối cùng
      final fileList = await driveApi.files.list(
        q: "'$folderId' in parents and trashed=false",
        spaces: 'drive',
        orderBy: 'modifiedTime desc',
        $fields: 'files(id, name, modifiedTime)',
        pageSize: 1, // Chỉ lấy 1 tệp có lần sửa đổi cuối gần nhất
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        final mostRecentFile = fileList.files!.first;
        log('Most recently modified file: ${mostRecentFile.name} (${mostRecentFile.id})');
        return mostRecentFile;
      } else {
        log('No files found in the folder.');
        return null;
      }
    } catch (e) {
      log('Error getting most recently modified file: $e');
      throw CustomException('Error getting most recently modified file: $e');
    }
  }

  Future<String?> getIdFileByName(String name,
      {drive.DriveApi? driveApi, String? idFolderParents}) async {
    try {
      driveApi ??= await getDriveApi();

      final fileList = await driveApi.files.list(
        q: "${idFolderParents != null ? "'$idFolderParents' in parents and " : ""} name='$name' and trashed=false",
        spaces: 'drive',
        $fields: 'files(id)',
        pageSize: 1, // Chỉ lấy 1 tệp có lần sửa đổi cuối gần nhất
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        final mostRecentFile = fileList.files!.first;
        log('File found: (${mostRecentFile.id})');
        return mostRecentFile.id;
      } else {
        log('No files found with the name: $name');
        return null;
      }
    } catch (e) {
      log('Error getting file by name: $e');
      throw CustomException('Error getting file by name: $e');
    }
  }

  Future<Uint8List?> downloadFile(String fileId,
      {drive.DriveApi? driveApi}) async {
    try {
      driveApi ??= await getDriveApi();

      final mediaStream = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final List<int> dataStore = [];
      await for (final data in mediaStream.stream) {
        dataStore.addAll(data);
      }

      log('File downloaded: $fileId');
      return Uint8List.fromList(dataStore);
    } catch (e) {
      log('Error downloading file: $e');
      throw CustomException('Error downloading file: $e');
    }
  }

  Future<void> deleteAllFilesInFolder(String folderId,
      {drive.DriveApi? driveApi}) async {
    try {
      driveApi ??= await getDriveApi();

      final fileList = await driveApi.files.list(
        q: "'$folderId' in parents and trashed=false",
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        for (var file in fileList.files!) {
          await driveApi.files.delete(file.id!);
          log('File deleted: ${file.name}');
        }
        log('All files in the folder have been deleted.');
      } else {
        log('No files found in the folder.');
      }
    } catch (e) {
      log('Error deleting files: $e');
      throw CustomException('Error deleting file: $e');
    }
  }
}
