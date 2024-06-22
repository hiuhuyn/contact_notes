import 'package:image_picker/image_picker.dart';
import 'package:contact_notes/app/domain/repository/media_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class PickMultiImageFromGallery
    extends UsecaseOneVariable<DataState<List<XFile>>, int?> {
  MediaRepository repository;
  PickMultiImageFromGallery(this.repository);

  @override
  Future<DataState<List<XFile>>> call(int? limit) async {
    return await repository.pickMultiImageFromGallery(limit: limit);
  }
}
