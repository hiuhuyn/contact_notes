import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:contact_notes/app/domain/usecases/media/pick_image_from_camera.dart';
import 'package:contact_notes/app/domain/usecases/media/pick_multi_image_from_gallery.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_state.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_cubit.dart';
import 'package:contact_notes/app/presentaion/pages/people_note/information/body/information_body.dart';
import 'package:contact_notes/app/presentaion/pages/people_note/information/body/relationships_body.dart';
import 'package:contact_notes/app/presentaion/pages/people_note/information/header.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/setup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class InformationPeopleScreen extends StatefulWidget {
  InformationPeopleScreen._({this.idLabel, this.peopleNote});
  String? idLabel;
  PeopleNote? peopleNote;
  factory InformationPeopleScreen.update({
    required PeopleNote peopleNote,
  }) {
    return InformationPeopleScreen._(
      peopleNote: peopleNote,
    );
  }
  factory InformationPeopleScreen.create({
    String? idLabel,
  }) {
    return InformationPeopleScreen._(
      idLabel: idLabel,
    );
  }

  @override
  State<InformationPeopleScreen> createState() =>
      _InformationPeopleScreenState();
}

class _InformationPeopleScreenState extends State<InformationPeopleScreen> {
  final _pageController = PageController();
  int _selectedPageIndex = 0;

  List<NoteLabel> allNoteLabel = [];
  late PeopleNote people;
  NoteLabel? label;

  @override
  void initState() {
    super.initState();
    people = widget.peopleNote?.copyWith() ??
        PeopleNote(name: "", idLabel: widget.idLabel);
    var state = context.read<NoteLabelCubit>().state;
    if (state is NoteLabelLoadedState && state.notes != null) {
      allNoteLabel = state.notes!;
      for (var element in allNoteLabel) {
        if (element.id == people.idLabel) {
          label = element;
          break;
        }
      }
    } else {
      context.read<NoteLabelCubit>().loaded().then(
        (value) {
          state = context.read<NoteLabelCubit>().state;
          if (state is NoteLabelLoadedState && state.notes != null) {
            setState(() {
              allNoteLabel = state.notes!;
              for (var element in allNoteLabel) {
                if (element.id == people.idLabel) {
                  label = element;
                  break;
                }
              }
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                label = value;
                people.idLabel = value.id;
              });
            },
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(label?.name ?? ""),
                const SizedBox(width: 10),
                Icon(
                  Icons.label,
                  color: label?.color != null ? Color(label!.color!) : null,
                ),
              ],
            ),
            itemBuilder: (context) {
              return allNoteLabel.map(
                (e) {
                  return PopupMenuItem(value: e, child: Text("${e.name}"));
                },
              ).toList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () async {
              await _showBottomNavigationAddPhoto(context);
            },
          ),
          if (widget.peopleNote != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _delete(context);
              },
            ),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            children: [
              HeaderInformaionPeople(
                photos: people.photos,
                height: _selectedPageIndex == 1 || isKeyboardVisible ? 30 : 200,
                onTapImageEmpty: () async {
                  await _showBottomNavigationAddPhoto(context);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTag(AppLocalizations.of(context)!.information, 0),
                  _buildTag(AppLocalizations.of(context)!.relationship, 1),
                ],
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, bottom: 8, right: 8, left: 8),
                    child: PageView(
                      onPageChanged: (index) {
                        setState(() {
                          _selectedPageIndex = index;
                          FocusScope.of(context).unfocus();
                        });
                      },
                      controller: _pageController,
                      children: [
                        InformationBody(
                          people: people,
                          padding: const EdgeInsets.only(bottom: 80),
                        ),
                        RelationshipsBody(
                          people: people,
                          padding: const EdgeInsets.only(bottom: 80),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 50,
            color: Colors.transparent,
            margin: const EdgeInsets.only(right: 8.0, bottom: 8.0, left: 8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () async {
                  await _save();
                },
                child: Text(AppLocalizations.of(context)!.save,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  void _onTagTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTag(String text, int index) {
    return GestureDetector(
      onTap: () => _onTagTapped(index),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedPageIndex == index
                  ? Colors.blue
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedPageIndex == index ? Colors.blue : null,
          ),
        ),
      ),
    );
  }

  Future _showBottomNavigationAddPhoto(BuildContext ctx) async {
    await showDialog(
      context: ctx,
      builder: (context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.add_images),
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(AppLocalizations.of(context)!.camera),
              onTap: () async {
                Navigator.pop(context);
                final result = await sl<PickImageFromCamera>().call();
                if (result is DataSuccess && result.data != null) {
                  setState(() {
                    people.photos ??= [];
                    people.photos!.add(result.data!.path);
                  });
                } else {
                  final snackBar = SnackBar(
                    content: Text(
                      "${result.error?.messange}",
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                }
              },
            ),
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.gallery),
                onTap: () async {
                  Navigator.pop(context);
                  final result =
                      await sl<PickMultiImageFromGallery>().call(null);
                  if (result is DataSuccess) {
                    setState(() {
                      people.photos ??= [];
                      people.photos!.addAll(result.data!
                          .map(
                            (e) => e.path,
                          )
                          .toList());
                    });
                  } else {
                    final snackBar = SnackBar(
                      content: Text(
                        "${result.error?.messange}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                  }
                })
          ],
        );
      },
    );
  }

  Future _save() async {
    FocusScope.of(context).unfocus();
    if (people.name == null || people.name!.isEmpty) {
      return;
    }
    if (widget.peopleNote != null) {
      // update
      context.read<PeopleNoteCubit>().updatePeopleNote(people);
      Navigator.pop(context);
    } else {
      // create
      await context.read<PeopleNoteCubit>().addPeopleNote(people).then(
        (value) {
          Navigator.pop(context);
        },
      );
    }
  }

  Future _delete(BuildContext ctx) async {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete),
        content:
            Text(AppLocalizations.of(context)!.are_you_sure_you_want_to_delete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              await context
                  .read<PeopleNoteCubit>()
                  .deletePeopleNote(widget.peopleNote!)
                  .then(
                (value) {
                  Navigator.pop(context, "delete");
                },
              );
            },
            child: Text(AppLocalizations.of(context)!.delete.toLowerCase()),
          ),
        ],
      ),
    ).then(
      (value) {
        if (value == "delete") {
          Navigator.pop(context);
        }
      },
    );
  }
}
