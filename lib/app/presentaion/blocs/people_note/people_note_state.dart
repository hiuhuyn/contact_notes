// ignore_for_file: must_be_immutable, overridden_fields

import 'package:equatable/equatable.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/core/exceptions/custom_exception.dart';

abstract class PeopleNoteState extends Equatable {
  List<PeopleNote>? allPeoples;
  List<PeopleNote>? subPeoples;

  CustomException? error;
  PeopleNoteState({this.allPeoples, this.error, this.subPeoples});

  @override
  List<Object?> get props => [allPeoples, error, subPeoples];
}

class PeopleNoteInitialState extends PeopleNoteState {}

class PeopleNoteLoadingState extends PeopleNoteState {}

class PeopleNoteLoadedState extends PeopleNoteState {
  PeopleNoteLoadedState(
      {required List<PeopleNote> allPeoples, List<PeopleNote>? subPeoples})
      : super(allPeoples: allPeoples, subPeoples: subPeoples);
}

class PeopleNoteErrorState extends PeopleNoteState {
  PeopleNoteErrorState(CustomException error) : super(error: error);
}
