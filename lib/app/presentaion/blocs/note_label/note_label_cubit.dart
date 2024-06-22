import 'package:bloc/bloc.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/usecases/note_label/create_note_label.dart';
import 'package:contact_notes/app/domain/usecases/note_label/delete_note_label.dart';
import 'package:contact_notes/app/domain/usecases/note_label/get_all_note_labels.dart';
import 'package:contact_notes/app/domain/usecases/note_label/update_note_label.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_state.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';

class NoteLabelCubit extends Cubit<NoteLabelState> {
  GetAllNoteLabels getAllNoteLabelsUC;
  CreateNoteLabel createNoteLabelUC;
  UpdateNoteLabel updateNoteLabelUC;
  DeleteNoteLabel deleteNoteLabelUC;
  NoteLabelCubit(
      {required this.getAllNoteLabelsUC,
      required this.createNoteLabelUC,
      required this.deleteNoteLabelUC,
      required this.updateNoteLabelUC})
      : super(NoteLabelInitialState());
  Future loaded() async {
    try {
      emit(NoteLabelLoadingState());
      final noteLabels = await getAllNoteLabelsUC(());
      if (noteLabels is DataSuccess) {
        emit(NoteLabelLoadedState(noteLabels.data!));
      } else {
        emit(NoteLabelErrorState(noteLabels.error!));
      }
    } catch (e) {
      emit(NoteLabelErrorState(
          CustomException('Failed to load note labels ($e)')));
    }
  }

  Future createNoteLabel(NoteLabel value) async {
    try {
      NoteLabelState? newState;
      if (state is NoteLabelLoadedState) {
        newState = state;
      }
      emit(NoteLabelLoadingState());
      final noteLabel = await createNoteLabelUC(value);
      if (noteLabel is DataSuccess) {
        if (newState != null) {
          newState.notes!.add(noteLabel.data!);
          emit(NoteLabelLoadedState(newState.notes!));
        } else {
          await loaded();
        }
      } else {
        emit(NoteLabelErrorState(noteLabel.error!));
      }
    } catch (e) {
      emit(NoteLabelErrorState(
          CustomException('Failed to create note label ($e)')));
    }
  }

  Future updateNoteLabel(NoteLabel value) async {
    try {
      NoteLabelState? newState;
      if (state is NoteLabelLoadedState) {
        newState = state;
      }
      emit(NoteLabelLoadingState());
      final noteLabel = await updateNoteLabelUC(value);
      if (noteLabel is DataSuccess) {
        if (newState != null) {
          int index = newState.notes!.indexWhere((note) => note.id == value.id);
          newState.notes![index] = noteLabel.data!;
          emit(NoteLabelLoadedState(newState.notes!));
        } else {
          await loaded();
        }
      } else {
        emit(NoteLabelErrorState(noteLabel.error!));
      }
    } catch (e) {
      emit(NoteLabelErrorState(
          CustomException('Failed to update note label ($e)')));
    }
  }

  Future deleteNoteLabel(String id) async {
    try {
      NoteLabelState? newState;
      if (state is NoteLabelLoadedState) {
        newState = state;
      }
      emit(NoteLabelLoadingState());
      final noteLabel = await deleteNoteLabelUC(id);
      if (noteLabel is DataSuccess) {
        if (newState != null) {
          newState.notes!.removeWhere((note) => note.id == id);
          emit(NoteLabelLoadedState(newState.notes!));
        } else {
          await loaded();
        }
      } else {
        emit(NoteLabelErrorState(noteLabel.error!));
      }
    } catch (e) {
      emit(NoteLabelErrorState(
          CustomException('Failed to delete note label ($e)')));
    }
  }
}
