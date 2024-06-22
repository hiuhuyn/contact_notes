import 'dart:developer';
import 'dart:io';

import 'package:contact_notes/app/data/data_sources/local/file_service.dart';
import 'package:contact_notes/app/data/data_sources/local/people_note_database.dart';
import 'package:contact_notes/app/data/data_sources/local/relationship_database.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/entity/relationship.dart';
import 'package:contact_notes/app/domain/repository/people_note_repository.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';

class PeopleNoteRepositoryIml implements PeopleNoteRepository {
  FileService fileService;
  PeopleNoteDatabase peopleNoteDatabaseLocal;
  RelationshipDatabase relationshipDatabaseLocal;
  PeopleNoteRepositoryIml(this.fileService, this.peopleNoteDatabaseLocal,
      this.relationshipDatabaseLocal);
  @override
  Future<DataState<PeopleNote>> createPeopleNote(PeopleNote value) async {
    try {
      if (value.photos != null) {
        for (int i = 0; i < value.photos!.length; i++) {
          value.photos![i] =
              await fileService.copyFileImageToAppDirectory(value.photos![i]);
        }
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to save photos ($e)"));
    }
    try {
      if (value.relationships != null) {
        for (var element in value.relationships!) {
          await relationshipDatabaseLocal
              .insert(element[Relationship.stringUseMap]);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    try {
      await peopleNoteDatabaseLocal.insert(value);
      return DataSuccess(value);
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to save data ($e)"));
    }
  }

  @override
  Future<DataState> deletePeopleNote(PeopleNote value) async {
    try {
      await peopleNoteDatabaseLocal.delete<String>(value.id!);
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to delete data ($e)"));
    }
    try {
      final relationshipByIdPerson =
          await relationshipDatabaseLocal.queryByKeyWork(value.id!);
      if (relationshipByIdPerson != null) {
        for (var element in relationshipByIdPerson) {
          await relationshipDatabaseLocal.delete(element.id!);
        }
      }
      for (var i in value.photos!) {
        await fileService.deleteFile(i);
      }
    } catch (e) {
      log(e.toString());
      // return DataFailed(CustomException("Failed to delete photos ($e)"));
    }
    return const DataSuccess(());
  }

  @override
  Future<DataState<List<PeopleNote>>> getAllPeopleNotes() async {
    try {
      List<PeopleNote> result = await peopleNoteDatabaseLocal.queryAllRows();
      for (int index = 0; index < result.length; index++) {
        if (result[index].photos != null) {
          final listCheck = <String>[];
          for (int i = 0; i < result[index].photos!.length; i++) {
            File test = File(result[index].photos![i]);
            final elementTestFile = await test.exists();
            if (elementTestFile) {
              listCheck.add(result[index].photos![i]);
            }
            // log("name: ${result[index].name} --check $elementTestFile index/size: $i/${result[index].photos!.length}");
          }
          if (listCheck.length != result[index].photos!.length) {
            result[index].photos = listCheck;
            await updatePeopleNote(result[index]);
          }
        }
      }
      return DataSuccess(result);
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to get data ($e)"));
    }
  }

  @override
  Future<DataState<List<PeopleNote>>> getPeopleNoteByLabel(String id) async {
    try {
      List<PeopleNote>? result =
          await peopleNoteDatabaseLocal.queryByIdLabel(id);
      if (result != null) {
        for (int index = 0; index < result.length; index++) {
          if (result[index].photos != null) {
            final listCheck = <String>[];
            for (int i = 0; i < result[index].photos!.length; i++) {
              File test = File(result[index].photos![i]);
              final elementTestFile = await test.exists();
              if (elementTestFile) {
                listCheck.add(result[index].photos![i]);
              }
            }
            if (listCheck.length != result[index].photos!.length) {
              result[index].photos = listCheck;
              await updatePeopleNote(result[index]);
            }
          }
        }
        return DataSuccess(result);
      } else {
        return DataFailed(CustomException("Data not found"));
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to get data ($e)"));
    }
  }

  @override
  Future<DataState<PeopleNote>> updatePeopleNote(PeopleNote value) async {
    PeopleNote? oldNote;
    // lấy dữ liệu cũ để so sánh path của các photo với các path photo mới
    oldNote = await peopleNoteDatabaseLocal.queryById(value.id!);
    if (oldNote == null) {
      return await createPeopleNote(value);
    }
    try {
      // update photo
      if (value.photos == null && oldNote.photos != null) {
        // Xóa tất cả file cũ nến danh sách photo mới rỗng
        for (int i = 0; i < oldNote.photos!.length; i++) {
          await fileService.deleteFile(oldNote.photos![i]);
        }
      } else if (oldNote.photos != null && value.photos != null) {
        // Tìm kiếm các path có trong new mà không có trong old rồi xóa các path và file old
        for (int i = 0; i < oldNote.photos!.length; i++) {
          int index = value.photos!.indexWhere(
            (element) => element == oldNote!.photos![i],
          );
          if (index == -1) {
            await fileService.deleteFile(oldNote.photos![i]);
            oldNote.photos!.removeAt(i);
          }
        }
        //Tìm kiếm các path có trong new mà khôn có trong old rồi thêm các path và file new
        for (int i = 0; i < value.photos!.length; i++) {
          int index = oldNote.photos!.indexWhere(
            (element) => element == value.photos![i],
          );
          if (index == -1) {
            value.photos![i] =
                await fileService.copyFileImageToAppDirectory(value.photos![i]);
          }
        }
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to update path photo ($e)"));
    }
    try {
      final oldList = await relationshipDatabaseLocal.queryByKeyWork(value.id!);

      if (value.relationships != null && oldList == null) {
        // them mới toàn bo
        log("add all relationships");
        for (var element in value.relationships!) {
          await relationshipDatabaseLocal
              .insert(element[Relationship.stringUseMap]);
        }
      } else if (value.relationships != null &&
          value.relationships!.isNotEmpty &&
          oldList != null) {
        // delete và update , insert
        log("delete và update or insert");
        List<Relationship> itemsToRemove = [];
        List<Relationship> newList = [];
        for (var element in value.relationships!) {
          newList.add(element[Relationship.stringUseMap]);
        }
        for (var oldItem in oldList) {
          var matchingNewItem = newList.firstWhere(
            (e) => e.id == oldItem.id,
            orElse: () => Relationship(
              id: -1,
            ), // Trả về một phần tử không hợp lệ nếu không tìm thấy
          );

          if (matchingNewItem.id == -1) {
            // Nếu không tìm thấy trong danh sách mới, thêm vào danh sách cần xóa
            itemsToRemove.add(oldItem);
          }
        }
        // Xóa các phần tử không có trong danh sách mới
        for (var item in itemsToRemove) {
          oldList.remove(item);
          await relationshipDatabaseLocal.delete(item.id!);
        }

        // Thêm các phần tử mới không có trong danh sách cũ
        for (var newItem in newList) {
          var matchingOldItem = oldList.firstWhere(
            (e) => e.id == newItem.id,
            orElse: () => Relationship(
              id: -1,
            ), // Trả về một phần tử không hợp lệ nếu không tìm thấy
          );

          if (matchingOldItem.id == -1) {
            // Nếu không tìm thấy trong danh sách cũ, thêm vào danh sách cũ
            await relationshipDatabaseLocal.insert(newItem);
          } else {
            // Nếu tìm thấy trong danh sách cũ, cập nhật thông tin
            await relationshipDatabaseLocal.update(newItem);
          }
        }
      } else if (oldList != null &&
          value.relationships != null &&
          value.relationships!.isEmpty) {
        // delete all
        log("delete all");
        for (var element in oldList) {
          await relationshipDatabaseLocal.delete(element.id!);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    try {
      await peopleNoteDatabaseLocal.update(value);
      return DataSuccess(value);
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to update data ($e)"));
    }
  }

  @override
  Future<DataState<PeopleNote>> getPeopleNoteById(String id) async {
    try {
      final result = await peopleNoteDatabaseLocal.queryById(id);
      if (result != null) {
        if (result.photos != null) {
          final listCheck = <String>[];
          for (int i = 0; i < result.photos!.length; i++) {
            File test = File(result.photos![i]);
            final resultTestFile = await test.exists();
            if (resultTestFile) {
              listCheck.add(result.photos![i]);
            }
          }
          if (listCheck.length != result.photos!.length) {
            result.photos = listCheck;
            return await updatePeopleNote(result);
          }
        }
        return DataSuccess(result);
      } else {
        return DataFailed(CustomException("Data not found"));
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to get data ($e)"));
    }
  }

  @override
  Future<DataState<List<PeopleNote>>> getPeopleNoteByName(String name) async {
    try {
      final result = await peopleNoteDatabaseLocal.queryByKeyWork(name);
      if (result != null) {
        for (int index = 0; index < result.length; index++) {
          if (result[index].photos != null) {
            final listCheck = <String>[];
            for (int i = 0; i < result[index].photos!.length; i++) {
              File test = File(result[index].photos![i]);
              final elementTestFile = await test.exists();
              if (elementTestFile) {
                listCheck.add(result[index].photos![i]);
              }
            }
            if (listCheck.length != result[index].photos!.length) {
              result[index].photos = listCheck;
              await updatePeopleNote(result[index]);
            }
          }
        }
        return DataSuccess(result);
      } else {
        return DataFailed(CustomException("Data not found"));
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to get data ($e)"));
    }
  }

  @override
  Future<DataState<List<PeopleNote>>> getPeopleNoteByLabelAndName(
      String idLabel, String name) async {
    try {
      final result =
          await peopleNoteDatabaseLocal.queryByLabelAndName(idLabel, name);
      if (result != null) {
        for (int index = 0; index < result.length; index++) {
          if (result[index].photos != null) {
            final listCheck = <String>[];
            for (int i = 0; i < result[index].photos!.length; i++) {
              File test = File(result[index].photos![i]);
              final elementTestFile = await test.exists();
              if (elementTestFile) {
                listCheck.add(result[index].photos![i]);
              }
            }
            if (listCheck.length != result[index].photos!.length) {
              result[index].photos = listCheck;
              await updatePeopleNote(result[index]);
            }
          }
        }
        return DataSuccess(result);
      } else {
        return DataFailed(CustomException("Data not found"));
      }
    } catch (e) {
      log(e.toString());
      return DataFailed(CustomException("Failed to get data ($e)"));
    }
  }

  @override
  Future<DataState> deleteAll() async {
    try {
      await peopleNoteDatabaseLocal.deleteAllRow();
      return const DataSuccess(());
    } catch (e) {
      return DataFailed(
          CustomException(e.toString(), errorType: ErrorType.unknown));
    }
  }
}
