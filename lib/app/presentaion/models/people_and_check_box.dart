import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/entity/relationship.dart';

class PeopleItemModel {
  PeopleNote peopleNote;
  bool isSelected;
  Relationship? relationship;
  PeopleItemModel(
      {required this.peopleNote, required this.isSelected, this.relationship});
}
