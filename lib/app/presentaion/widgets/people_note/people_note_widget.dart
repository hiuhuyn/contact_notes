import 'package:flutter/material.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget_basic_state.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget_use_check_box_state.dart';

// ignore: must_be_immutable
class PeopleNoteWidget extends StatefulWidget {
  PeopleNoteWidget._({
    required this.value,
    this.onCheckBoxChanged,
    this.initValueCheck = false,
    this.onFieldSubmittedDescription,
    this.onTap,
    this.initDescription,
  });
  PeopleNote value;
  Function(bool value)? onCheckBoxChanged;
  bool initValueCheck = false;
  Function(String value)? onFieldSubmittedDescription;
  String? initDescription;

  Function()? onTap;

  factory PeopleNoteWidget.basic(
      {required PeopleNote value, Function()? onTap}) {
    return PeopleNoteWidget._(
      value: value,
      onTap: onTap,
    );
  }

  factory PeopleNoteWidget.useCheckBox({
    required PeopleNote value,
    required Function(bool value) onCheckBoxChanged,
    Function()? onTap,
    required bool initValueCheck,
    Function(String value)? onFieldSubmittedDescription,
    String initDescription = "",
  }) {
    return PeopleNoteWidget._(
      value: value,
      initValueCheck: initValueCheck,
      onCheckBoxChanged: onCheckBoxChanged,
      onTap: onTap,
      onFieldSubmittedDescription: onFieldSubmittedDescription,
      initDescription: initDescription,
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<PeopleNoteWidget> createState() {
    if (onCheckBoxChanged != null) {
      return PeopleNoteWidgetUseCheckBoxState();
    } else {
      return PeopleNoteWidgetBasicState();
    }
  }
}
