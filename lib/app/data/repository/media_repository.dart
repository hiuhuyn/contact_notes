import 'package:image_picker/image_picker.dart';
import 'package:contact_notes/app/data/data_sources/local/local_media_source.dart';
import 'package:contact_notes/app/domain/repository/media_repository.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';

class MediaRepositoryIml extends MediaRepository {
  final MediaService _mediaService;
  MediaRepositoryIml(this._mediaService);
  @override
  Future<DataState<XFile>> pickImageFromCamera() async {
    try {
      final result = await _mediaService.pickImageFromCamera();
      if (result != null) {
        return DataSuccess(result);
      } else {
        throw CustomException("No image available",
            errorType: ErrorType.continuable);
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState<XFile>> pickImageFromGallery() async {
    try {
      final result = await _mediaService.pickImageFromGallery();
      if (result != null) {
        return DataSuccess(result);
      } else {
        throw CustomException("No image available",
            errorType: ErrorType.continuable);
      }
    } on CustomException catch (e) {
      return DataFailed(e);
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }

  @override
  Future<DataState<List<XFile>>> pickMultiImageFromGallery({int? limit}) async {
    try {
      final result = await _mediaService.pickMultiImageFromCamera(limit: limit);
      if (result.isEmpty) {
        throw CustomException("No image available",
            errorType: ErrorType.continuable);
      }
      return DataSuccess(result);
    } on CustomException catch (e) {
      return DataFailed(e);
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }
}
