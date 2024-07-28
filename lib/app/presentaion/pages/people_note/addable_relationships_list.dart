import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_state.dart';
import 'package:contact_notes/app/presentaion/models/people_and_check_box.dart';
import 'package:contact_notes/app/presentaion/widgets/errors/empty_data.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class AddableRelationshipsList extends StatefulWidget {
  AddableRelationshipsList({super.key, required this.relationships, this.id});
  List<int> relationships;
  int? id;

  @override
  State<AddableRelationshipsList> createState() =>
      _AddableRelationshipsListState();
}

class _AddableRelationshipsListState extends State<AddableRelationshipsList> {
  List<PeopleItemModel> allPeopleNotes = [];
  final searchTextController = TextEditingController();
  final searchFocus = FocusNode();
  final InputBorder borderInputUnFocus = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(color: Colors.grey.shade500),
  );
  final InputBorder focusedBorder = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
  );
  @override
  void initState() {
    super.initState();
    context.read<PeopleNoteCubit>().searchPeopleNoteByName("");
  }

  @override
  void dispose() {
    searchFocus.unfocus();
    searchTextController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        leading: IconButton(
            onPressed: () {
              searchFocus.unfocus();
              final result = <PeopleNote>[];
              for (var element in allPeopleNotes) {
                if (element.isSelected) {
                  result.add(element.peopleNote);
                }
              }
              Navigator.pop(
                context,
                result,
              );
            },
            icon: const Icon(Icons.arrow_back)),
        title: TextFormField(
          controller: searchTextController,
          focusNode: searchFocus,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              border: borderInputUnFocus,
              enabledBorder: borderInputUnFocus,
              focusedBorder: focusedBorder,
              hintText: AppLocalizations.of(context)!.search,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                  onPressed: () {
                    searchTextController.clear();
                    searchFocus.unfocus();
                    context.read<PeopleNoteCubit>().searchPeopleNoteByName("");
                  },
                  icon: const Icon(Icons.close))),
          onChanged: (value) {
            context.read<PeopleNoteCubit>().searchPeopleNoteByName(value);
          },
          onFieldSubmitted: (newValue) {
            FocusScope.of(context).unfocus();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: BlocBuilder<PeopleNoteCubit, PeopleNoteState>(
                  builder: (context, state) {
                if (state is PeopleNoteInitialState ||
                    state is PeopleNoteLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PeopleNoteErrorState) {
                  return EmptyDataWidget();
                }
                allPeopleNotes.clear();
                for (var e in state.subPeoples!) {
                  int indexWhere = widget.relationships.indexWhere(
                    (element) => element == e.id!,
                  );
                  if (e.id != widget.id) {
                    allPeopleNotes.add(PeopleItemModel(
                        peopleNote: e, isSelected: indexWhere != -1));
                  }
                }
                if (allPeopleNotes.isEmpty) {
                  return EmptyDataWidget();
                }
                return ListView.builder(
                  itemCount: allPeopleNotes.length,
                  itemBuilder: (context, index) {
                    return PeopleNoteWidget.useCheckBox(
                        value: allPeopleNotes[index].peopleNote,
                        onCheckBoxChanged: (value) {
                          allPeopleNotes[index].isSelected = value;
                          log(allPeopleNotes[index].isSelected.toString());
                        },
                        initValueCheck: allPeopleNotes[index].isSelected);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
