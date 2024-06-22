import 'package:image_picker/image_picker.dart';
import 'package:contact_notes/app/domain/repository/media_repository.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';

class PickImageFromGallery extends UsecaseNoVariable<DataState<XFile>> {
  MediaRepository repository;
  PickImageFromGallery(this.repository);

  @override
  Future<DataState<XFile>> call() async {
    return await repository.pickImageFromGallery();
  }
}
