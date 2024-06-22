// ignore_for_file: must_be_immutable, overridden_fields

import 'package:equatable/equatable.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';

abstract class NoteLabelState extends Equatable {
  List<NoteLabel>? notes;
  CustomException? error;
  NoteLabelState({this.notes, this.error});

  @override
  List<Object?> get props => [notes, error];
}

class NoteLabelInitialState extends NoteLabelState {}

class NoteLabelLoadingState extends NoteLabelState {}

class NoteLabelLoadedState extends NoteLabelState {
  NoteLabelLoadedState(List<NoteLabel> notes) : super(notes: notes);
}

class NoteLabelErrorState extends NoteLabelState {
  NoteLabelErrorState(CustomException error) : super(error: error);
}
