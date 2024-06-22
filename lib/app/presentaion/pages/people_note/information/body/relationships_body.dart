import 'package:flutter/material.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/entity/relationship.dart';
import 'package:contact_notes/app/domain/usecases/people_note/get_people_note_by_id.dart';
import 'package:contact_notes/app/domain/usecases/relationship/get_relationships_by_person_id.dart';
import 'package:contact_notes/app/presentaion/models/people_and_check_box.dart';
import 'package:contact_notes/app/presentaion/widgets/errors/empty_data.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget.dart';
import 'package:contact_notes/core/router/app_router.dart';
import 'package:contact_notes/setup.dart';

// ignore: must_be_immutable
class RelationshipsBody extends StatefulWidget {
  RelationshipsBody({super.key, required this.people, this.padding});
  PeopleNote people;
  EdgeInsetsGeometry? padding;

  @override
  State<RelationshipsBody> createState() => _RelationshipsBodyState();
}

class _RelationshipsBodyState extends State<RelationshipsBody> {
  List<PeopleItemModel> relationships = [];
  @override
  void initState() {
    super.initState();
    if (widget.people.id != null) {
      if (widget.people.relationships != null &&
          widget.people.relationships!.isNotEmpty) {
        for (var e in widget.people.relationships!) {
          setState(() {
            relationships.add(PeopleItemModel(
                peopleNote: e[PeopleNote.stringUseMap],
                isSelected: true,
                relationship: e[Relationship.stringUseMap]));
          });
        }
      } else {
        sl<GetRelationshipsByPersonId>().call(widget.people.id!).then(
          (value) {
            if (value.data != null) {
              relationships = [];
              widget.people.relationships = [];
              for (var element in value.data!) {
                sl<GetPeopleNoteById>()
                    .call(widget.people.id == element.idPerson1
                        ? element.idPerson2!
                        : element.idPerson1!)
                    .then(
                  (value) {
                    setState(() {
                      if (value.data != null) {
                        relationships.add(PeopleItemModel(
                            peopleNote: value.data!,
                            isSelected: true,
                            relationship: element));
                        widget.people.relationships!.add({
                          Relationship.stringUseMap: element,
                          PeopleNote.stringUseMap: value.data
                        });
                      }
                    });
                  },
                );
              }
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (relationships.isEmpty) Expanded(child: EmptyDataWidget()),
          if (relationships.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: relationships.length,
                itemBuilder: (context, index) {
                  return PeopleNoteWidget.useCheckBox(
                      initDescription:
                          relationships[index].relationship?.description ?? "",
                      onFieldSubmittedDescription: (value) {
                        setState(() {
                          widget.people.relationships ??= [];
                          relationships[index].relationship =
                              relationships[index]
                                  .relationship
                                  ?.copyWith(description: value);

                          int indexWhere =
                              widget.people.relationships!.indexWhere((value) {
                            final t = value[Relationship.stringUseMap]
                                as Relationship;
                            return t.id ==
                                relationships[index].relationship?.id;
                          });
                          if (indexWhere == -1) {
                            widget.people.relationships!.add({
                              Relationship.stringUseMap:
                                  relationships[index].relationship!,
                              PeopleNote.stringUseMap:
                                  relationships[index].peopleNote
                            });
                          } else {
                            widget.people.relationships![indexWhere] = {
                              Relationship.stringUseMap:
                                  relationships[index].relationship!,
                              PeopleNote.stringUseMap:
                                  relationships[index].peopleNote
                            };
                          }
                        });
                      },
                      value: relationships[index].peopleNote,
                      onCheckBoxChanged: (value) {
                        setState(() {
                          relationships[index].isSelected = value;
                          final t = List<PeopleItemModel>.from(relationships);
                          t.removeWhere(
                            (element) => !element.isSelected,
                          );
                          widget.people.relationships = [];
                          for (var e in t) {
                            widget.people.relationships!.add({
                              Relationship.stringUseMap: e.relationship,
                              PeopleNote.stringUseMap: e.peopleNote
                            });
                          }
                        });
                      },
                      initValueCheck: relationships[index].isSelected);
                },
              ),
            ),
          GestureDetector(
            onTap: () async {
              final List<PeopleItemModel> t = List.from(relationships);
              t.removeWhere(
                (element) => !element.isSelected,
              );
              setState(() {
                relationships.clear();
                widget.people.relationships = [];
              });
              await AppRouter.navigateToAddableRelationshipsList(context,
                      id: widget.people.id,
                      relationships: t
                          .map<String>(
                            (e) => e.peopleNote.id!,
                          )
                          .toList())
                  .then(
                (value) {
                  setState(() {
                    for (var e in value) {
                      Relationship rs = Relationship(
                          idPerson1: widget.people.id, idPerson2: e.id);
                      int i = t.indexWhere(
                        (element) =>
                            element.relationship?.idPerson1 == e.id ||
                            element.relationship?.idPerson2 == e.id,
                      );
                      if (i != -1) {
                        rs = t[i].relationship!;
                      }
                      relationships.add(PeopleItemModel(
                          isSelected: true, peopleNote: e, relationship: rs));
                      widget.people.relationships!.add({
                        Relationship.stringUseMap: rs,
                        PeopleNote.stringUseMap: e
                      });
                    }
                  });
                },
              );
            },
            child: Container(
              height: 40,
              margin: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300]),
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
