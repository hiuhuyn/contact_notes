import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();
  double? maxWidth;
  double? maxHeight;
  int? quality;
  MediaService({this.maxWidth, this.maxHeight, this.quality});

  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: quality,
        maxWidth: maxWidth,
        maxHeight: maxHeight);
  }

  Future<XFile?> pickImageFromCamera() async {
    return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: quality,
        maxWidth: maxWidth,
        maxHeight: maxHeight);
  }

  Future<List<XFile>> pickMultiImageFromCamera({int? limit}) async {
    return await _picker.pickMultiImage(
      imageQuality: quality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      limit: limit,
    );
  }
}
