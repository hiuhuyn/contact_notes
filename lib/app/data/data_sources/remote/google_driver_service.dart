import 'dart:developer';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'firebase_service.dart'; // Import FirebaseService

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

  Future<String?> createFolder(String folderName) async {
    try {
      final driveApi = await getDriveApi();

      final drive.File folder = drive.File();
      folder.name = folderName;
      folder.mimeType = 'application/vnd.google-apps.folder';

      final createdFolder = await driveApi.files.create(folder);
      log('Folder created: ${createdFolder.id}');
      return createdFolder.id;
    } catch (e) {
      log('Error creating folder: $e');
      return null;
    }
  }

  Future<void> saveFileToFolder(String folderId, String fileName,
      Uint8List fileData, String mimeType) async {
    try {
      final driveApi = await getDriveApi();

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

  Future<List<drive.File>> listFilesInFolder(String folderId) async {
    try {
      final driveApi = await getDriveApi();
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
}
