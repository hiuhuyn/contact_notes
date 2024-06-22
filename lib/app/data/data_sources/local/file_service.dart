import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileService {
  Future<String> copyFileImageToAppDirectory(String oldPath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    final directoryPath = '${appDocDir.path}/images';

    final directory = Directory(directoryPath);

    if (!await directory.exists()) {
      await directory.create();
    }

    String fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${basename(oldPath)}";

    String newPath = join(directory.path, fileName);

    final fileNew = await File(oldPath).copy(newPath);

    return fileNew.path.trim();
  }

  Future<String> saveFileImageToAppDirectory(
      String fileName, Uint8List fileData) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    final directoryPath = '${appDocDir.path}/images';

    final directory = Directory(directoryPath);

    if (!await directory.exists()) {
      await directory.create();
    }

    String newPath = join(directory.path, fileName);

    final fileNew = File(newPath);
    if (!await fileNew.exists()) {
      fileNew.create();
      fileNew.writeAsBytes(fileData);
    }

    return fileNew.path.trim();
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> deleteDirectory() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final directoryPath = '${appDocDir.path}/images';
      final dir = Directory(directoryPath);

      if (await dir.exists()) {
        dir.listSync().forEach((file) {
          if (file is File) {
            file.deleteSync();
          }
        });
        log('All files deleted successfully');
      } else {
        log('Directory does not exist');
      }
    } catch (e) {
      throw CustomException('Error while deleting files: $e');
    }
  }

  Future<List<File>> getFileInFolderImages() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final directoryPath = '${appDocDir.path}/images';
      final dir = Directory(directoryPath);

      if (await dir.exists()) {
        List<File> files = [];
        dir.listSync().forEach((file) {
          if (file is File) {
            files.add(file);
          }
        });
        return files;
      } else {
        log('Directory does not exist');
        return [];
      }
    } catch (e) {
      throw CustomException('Error while deleting files: $e');
    }
  }
}
