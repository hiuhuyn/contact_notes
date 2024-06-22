import 'package:image_picker/image_picker.dart';
import 'package:contact_notes/core/state/data_sate.dart';

abstract class MediaRepository {
  Future<DataState<XFile>> pickImageFromGallery();
  Future<DataState<List<XFile>>> pickMultiImageFromGallery({int? limit});
  Future<DataState<XFile>> pickImageFromCamera();
}
