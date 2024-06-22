import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:contact_notes/app/data/data_sources/local/file_service.dart';
import 'package:contact_notes/app/data/data_sources/local/local_media_source.dart';
import 'package:contact_notes/app/data/data_sources/local/note_label_database.dart';
import 'package:contact_notes/app/data/data_sources/local/people_note_database.dart';
import 'package:contact_notes/app/data/data_sources/local/relationship_database.dart';
import 'package:contact_notes/app/data/data_sources/remote/firebase_service.dart';
import 'package:contact_notes/app/data/repository/auth_repository.dart';
import 'package:contact_notes/app/data/repository/media_repository.dart';
import 'package:contact_notes/app/data/repository/note_label_repository.dart';
import 'package:contact_notes/app/data/repository/people_note_repository.dart';
import 'package:contact_notes/app/data/repository/relationship_repository.dart';
import 'package:contact_notes/app/domain/repository/auth_repository.dart';
import 'package:contact_notes/app/domain/repository/media_repository.dart';
import 'package:contact_notes/app/domain/repository/note_label_repository.dart';
import 'package:contact_notes/app/domain/repository/people_note_repository.dart';
import 'package:contact_notes/app/domain/repository/relationship_repository.dart';
import 'package:contact_notes/app/domain/usecases/clear_database_local.dart';
import 'package:contact_notes/app/domain/usecases/google/sign_in_and_out_with_google.dart';
import 'package:contact_notes/app/domain/usecases/media/pick_image_from_camera.dart';
import 'package:contact_notes/app/domain/usecases/media/pick_image_from_gallery.dart';
import 'package:contact_notes/app/domain/usecases/media/pick_multi_image_from_gallery.dart';
import 'package:contact_notes/app/domain/usecases/note_label/create_note_label.dart';
import 'package:contact_notes/app/domain/usecases/note_label/delete_note_label.dart';
import 'package:contact_notes/app/domain/usecases/note_label/get_all_note_labels.dart';
import 'package:contact_notes/app/domain/usecases/note_label/get_note_label_by_id.dart';
import 'package:contact_notes/app/domain/usecases/note_label/update_note_label.dart';
import 'package:contact_notes/app/domain/usecases/people_note/create_people_note.dart';
import 'package:contact_notes/app/domain/usecases/people_note/delete_people_note.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_label.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_label_and_name.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_name.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_all_people_note.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_id.dart';
import 'package:contact_notes/app/domain/usecases/relationship/get_relationships_by_person_id.dart';
import 'package:contact_notes/app/domain/usecases/people_note/update_people_note.dart';
import 'package:contact_notes/app/domain/usecases/relationship/update_relationship.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_cubit.dart';
import 'package:googleapis/drive/v3.dart' as drive;

final sl = GetIt.instance;

Future setupDependencies() async {
  //services
  sl.registerLazySingleton<FirebaseService>(
    () => FirebaseService(
        FirebaseAuth.instance,
        GoogleSignIn(scopes: [
          drive.DriveApi.driveScope,
        ])),
  );
  sl.registerLazySingleton<FileService>(
    () => FileService(),
  );
  sl.registerLazySingleton<MediaService>(
    () => MediaService(quality: 100),
  );
  const fileDataName = "people_note09.db";
  final noteLabelDatabase = NoteLabelDatabase(fileName: fileDataName);
  await noteLabelDatabase.initDatabase();
  sl.registerLazySingleton<NoteLabelDatabase>(() => noteLabelDatabase);

  final peopleNoteDatabase = PeopleNoteDatabase(fileName: fileDataName);
  await peopleNoteDatabase.initDatabase();
  sl.registerLazySingleton<PeopleNoteDatabase>(() => peopleNoteDatabase);

  final relationshipDatabaseLocal =
      RelationshipDatabaseLocal(fileName: fileDataName);
  await relationshipDatabaseLocal.initDatabase();
  sl.registerLazySingleton<RelationshipDatabaseLocal>(
      () => relationshipDatabaseLocal);

  // repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryIml(sl()),
  );
  sl.registerLazySingleton<NoteLabelRepository>(
    () => NoteLabelRepositoryIml(sl(), sl()),
  );
  sl.registerLazySingleton<PeopleNoteRepository>(
    () => PeopleNoteRepositoryIml(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryIml(sl()),
  );
  sl.registerLazySingleton<RelationshipRepository>(
    () => RelationshipRepositoryIml(sl()),
  );

  // Use Case
  sl.registerLazySingleton<SignInAndOutWithGoogleUseCase>(
    () => SignInAndOutWithGoogleUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllNoteLabels>(
    () => GetAllNoteLabels(sl<NoteLabelRepository>()),
  );
  sl.registerLazySingleton<GetNoteLabelById>(
    () => GetNoteLabelById(sl<NoteLabelRepository>()),
  );
  sl.registerLazySingleton<CreateNoteLabel>(
    () => CreateNoteLabel(sl<NoteLabelRepository>()),
  );
  sl.registerLazySingleton<UpdateNoteLabel>(
    () => UpdateNoteLabel(sl<NoteLabelRepository>()),
  );
  sl.registerLazySingleton<DeleteNoteLabel>(
    () => DeleteNoteLabel(sl<NoteLabelRepository>()),
  );
  sl.registerLazySingleton<GetAllPeopleNotes>(
    () => GetAllPeopleNotes(sl()),
  );
  sl.registerLazySingleton<GetPeopleNoteById>(
    () => GetPeopleNoteById(sl()),
  );
  sl.registerLazySingleton<GetPeopleNotesByName>(
    () => GetPeopleNotesByName(sl()),
  );
  sl.registerLazySingleton<CreatePeopleNote>(
    () => CreatePeopleNote(sl()),
  );
  sl.registerLazySingleton<UpdatePeopleNote>(
    () => UpdatePeopleNote(sl()),
  );
  sl.registerLazySingleton<DeletePeopleNote>(
    () => DeletePeopleNote(sl()),
  );
  sl.registerLazySingleton<GetPeopleNotesByLabel>(
    () => GetPeopleNotesByLabel(sl()),
  );
  sl.registerLazySingleton<GetPeopleNotesByLabelAndName>(
    () => GetPeopleNotesByLabelAndName(sl()),
  );
  sl.registerLazySingleton<PickImageFromCamera>(
    () => PickImageFromCamera(sl()),
  );
  sl.registerLazySingleton<PickImageFromGallery>(
    () => PickImageFromGallery(sl()),
  );
  sl.registerLazySingleton<PickMultiImageFromGallery>(
    () => PickMultiImageFromGallery(sl()),
  );

  sl.registerLazySingleton<GetRelationshipsByPersonId>(
    () => GetRelationshipsByPersonId(sl()),
  );
  sl.registerLazySingleton<UpdateRelationship>(
    () => UpdateRelationship(sl()),
  );
  sl.registerLazySingleton<ClearDatabaseLocal>(
    () => ClearDatabaseLocal(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );

  // bloc  - cubit
  sl.registerLazySingleton<NoteLabelCubit>(
    () => NoteLabelCubit(
        getAllNoteLabelsUC: sl<GetAllNoteLabels>(),
        createNoteLabelUC: sl<CreateNoteLabel>(),
        deleteNoteLabelUC: sl<DeleteNoteLabel>(),
        updateNoteLabelUC: sl<UpdateNoteLabel>()),
  );
  sl.registerLazySingleton<PeopleNoteCubit>(
    () => PeopleNoteCubit(
      sl<GetAllPeopleNotes>(),
      sl<CreatePeopleNote>(),
      sl<UpdatePeopleNote>(),
      sl<GetPeopleNotesByName>(),
      sl<GetPeopleNotesByLabelAndName>(),
      sl<GetPeopleNotesByLabel>(),
      sl<DeletePeopleNote>(),
    ),
  );
}
