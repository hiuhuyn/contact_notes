import 'package:bloc/bloc.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/usecases/people_note/create_people_note.dart';
import 'package:contact_notes/app/domain/usecases/people_note/delete_people_note.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_label.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_label_and_name.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_name.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_all_people_note.dart';
import 'package:contact_notes/app/domain/usecases/people_note/update_people_note.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_state.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';

class PeopleNoteCubit extends Cubit<PeopleNoteState> {
  final GetAllPeopleNotes _getAllPeopleNotes;
  final CreatePeopleNote _createPeopleNoteUc;
  final UpdatePeopleNote _updatePeopleNoteUc;
  final DeletePeopleNote _deletePeople;
  final GetPeopleNotesByName _getPeopleNotesByNameUc;
  final GetPeopleNotesByLabelAndName _getPeopleNotesByLabelAndName;
  final GetPeopleNotesByLabel _getPeopleNotesByLabel;

  PeopleNoteCubit(
    this._getAllPeopleNotes,
    this._createPeopleNoteUc,
    this._updatePeopleNoteUc,
    this._getPeopleNotesByNameUc,
    this._getPeopleNotesByLabelAndName,
    this._getPeopleNotesByLabel,
    this._deletePeople,
  ) : super(PeopleNoteInitialState());

  Future addPeopleNote(PeopleNote peopleNote) async {
    PeopleNoteState? oldState = state is PeopleNoteLoadedState ? state : null;
    if (oldState == null) {
      await loaded();
      if (state is PeopleNoteLoadedState) {
        oldState = state;
      } else {
        emit(PeopleNoteErrorState(
            CustomException("Loading failed please try again")));
        return;
      }
    }
    emit(PeopleNoteLoadingState());
    try {
      final result = await _createPeopleNoteUc(peopleNote);
      if (result is DataSuccess) {
        oldState.allPeoples!.add(result.data!);
        oldState.subPeoples?.add(result.data!);
        emit(PeopleNoteLoadedState(
          allPeoples: List.from(oldState.allPeoples!),
          subPeoples: List.from(oldState.subPeoples ?? []),
        ));
      } else {
        throw CustomException(result.error!.message,
            errorType: result.error!.errorType);
      }
    } catch (e) {
      emit(PeopleNoteErrorState(CustomException("Add people note failed: $e")));
    }
  }

  Future updatePeopleNote(PeopleNote peopleNote) async {
    PeopleNoteState? oldState = state is PeopleNoteLoadedState ? state : null;
    if (oldState == null) {
      await loaded();
      if (state is PeopleNoteLoadedState) {
        oldState = state;
      } else {
        emit(PeopleNoteErrorState(
            CustomException("Loading failed please try again")));
        return;
      }
    }
    emit(PeopleNoteLoadingState());
    try {
      final result = await _updatePeopleNoteUc(peopleNote);
      if (result is DataSuccess) {
        int index = oldState.allPeoples!.indexWhere(
          (element) => element.id == result.data!.id,
        );
        if (index == -1) {
          oldState.allPeoples!.add(result.data!);
        } else {
          oldState.allPeoples![index] = result.data!;
        }
        index = oldState.subPeoples?.indexWhere(
              (element) => element.id == result.data!.id,
            ) ??
            -1;
        if (index == -1) {
          oldState.subPeoples?.add(result.data!);
        } else {
          oldState.subPeoples?[index] = result.data!;
        }
        emit(PeopleNoteLoadedState(
            allPeoples: List.from(oldState.allPeoples!),
            subPeoples:
                List.from(oldState.subPeoples ?? oldState.allPeoples!)));
      } else {
        throw CustomException(result.error!.message,
            errorType: result.error!.errorType);
      }
    } catch (e) {
      emit(PeopleNoteErrorState(
          CustomException("Update people note failed: $e")));
    }
  }

  Future deletePeopleNote(PeopleNote peopleNote) async {
    PeopleNoteState? oldState = state is PeopleNoteLoadedState ? state : null;
    if (oldState == null) {
      await loaded();
      if (state is PeopleNoteLoadedState) {
        oldState = state;
      } else {
        emit(PeopleNoteErrorState(
            CustomException("Loading failed please try again")));
        return;
      }
    }
    emit(PeopleNoteLoadingState());
    try {
      final result = await _deletePeople(peopleNote);
      if (result is DataSuccess) {
        oldState.allPeoples!.removeWhere(
          (element) => element.id == peopleNote.id,
        );
        emit(PeopleNoteLoadedState(
          allPeoples: List.from(oldState.allPeoples!),
          subPeoples: List.from(oldState.allPeoples!),
        ));
      } else {
        throw CustomException(result.error!.message,
            errorType: result.error!.errorType);
      }
    } catch (e) {
      emit(PeopleNoteErrorState(CustomException(e.toString())));
    }
  }

  Future searchPeopleNoteByName(String name) async {
    emit(PeopleNoteLoadingState());
    try {
      List<PeopleNote> allPeoples = List.from(await _reloatAllPeople());
      if (name.isEmpty) {
        emit(PeopleNoteLoadedState(
          allPeoples: List.from(allPeoples),
          subPeoples: List.from(allPeoples),
        ));
        return;
      }
      final result = await _getPeopleNotesByNameUc(name);
      if (result is DataSuccess) {
        emit(PeopleNoteLoadedState(
            allPeoples: allPeoples, subPeoples: result.data!));
      } else {
        throw CustomException(result.error!.message,
            errorType: result.error!.errorType);
      }
    } catch (e) {
      emit(PeopleNoteErrorState(CustomException(e.toString())));
    }
  }

  Future loadPeopleNoteByLabelAndName(int idLabel, String name) async {
    if (name.isEmpty) {
      loadPeopleNoteByLabel(idLabel);
      return;
    }
    try {
      List<PeopleNote> allPeoples = List.from(await _reloatAllPeople());
      final result = await _getPeopleNotesByLabelAndName(idLabel, name);
      if (result is DataSuccess) {
        emit(PeopleNoteLoadedState(
            allPeoples: allPeoples, subPeoples: result.data!));
      } else {
        throw CustomException(result.error!.message,
            errorType: result.error!.errorType);
      }
    } catch (e) {
      emit(PeopleNoteErrorState(CustomException(e.toString())));
    }
  }

  Future loadPeopleNoteByLabel(int idLabel) async {
    try {
      List<PeopleNote> allPeoples = List.from(await _reloatAllPeople());
      emit(PeopleNoteLoadingState());
      final result = await _getPeopleNotesByLabel(idLabel);
      if (result is DataSuccess) {
        emit(PeopleNoteLoadedState(
            allPeoples: allPeoples, subPeoples: result.data!));
      } else {
        throw CustomException(result.error!.message,
            errorType: result.error!.errorType);
      }
    } catch (e) {
      emit(PeopleNoteErrorState(CustomException(e.toString())));
    }
  }

  Future loaded() async {
    emit(PeopleNoteLoadingState());
    try {
      final result = await _getAllPeopleNotes(());
      if (result is DataSuccess) {
        emit(PeopleNoteLoadedState(
            allPeoples: List.from(result.data!),
            subPeoples: List.from(result.data!)));
      } else {
        throw CustomException(result.error!.message,
            errorType: result.error!.errorType);
      }
    } catch (e) {
      emit(PeopleNoteErrorState(CustomException("loaded failed: $e")));
    }
  }

  Future<List<PeopleNote>> _reloatAllPeople() async {
    List<PeopleNote>? allPeoples;
    if (state is PeopleNoteLoadedState) {
      allPeoples = List.from(state.allPeoples ?? []);
    } else {
      final result = await _getAllPeopleNotes(());
      if (result is DataSuccess) {
        allPeoples = result.data!;
      }
    }
    if (allPeoples != null) {
      return allPeoples;
    } else {
      throw CustomException("People note list is null, please try again");
    }
  }
}
