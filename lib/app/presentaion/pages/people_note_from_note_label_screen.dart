import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_state.dart';
import 'package:contact_notes/app/presentaion/widgets/app_drawer.dart';
import 'package:contact_notes/app/presentaion/widgets/errors/empty_data.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget.dart';
import 'package:contact_notes/core/router/app_router.dart';
import 'package:contact_notes/core/utils/color_picker_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class PeopleNoteFromNoteLabelScreen extends StatefulWidget {
  PeopleNoteFromNoteLabelScreen({super.key, required this.noteLabel});
  NoteLabel noteLabel;

  @override
  State<PeopleNoteFromNoteLabelScreen> createState() =>
      _PeopleNoteFromNoteLabelScreenState();
}

class _PeopleNoteFromNoteLabelScreenState
    extends State<PeopleNoteFromNoteLabelScreen> {
  final searchTextController = TextEditingController();
  final searchFocus = FocusNode();
  Color? colorLabel = Colors.white;
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
    if (widget.noteLabel.color != null) {
      colorLabel = Color(widget.noteLabel.color!);
    }
    context.read<PeopleNoteCubit>().loadPeopleNoteByLabel(widget.noteLabel.id!);
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
        title: Text(widget.noteLabel.name.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {},
          ),
          PopupMenuButton<int>(
            onSelected: (int value) async {
              switch (value) {
                case 0:
                  _updateRenameNoteLabel(context);
                  break;
                case 1:
                  await _updateColorNoteLabel(context);
                  break;
                case 2:
                  _deleteNoteLabel(context);
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(AppLocalizations.of(context)!.rename),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(AppLocalizations.of(context)!.change_color),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text(AppLocalizations.of(context)!.delete),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        tag: DrawerTag.noteLabel,
        idNoteLabelSelect: widget.noteLabel.id,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, right: 8, bottom: 16, left: 8),
              child: TextFormField(
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
                          context
                              .read<PeopleNoteCubit>()
                              .loadPeopleNoteByLabel(widget.noteLabel.id!);
                        },
                        icon: const Icon(Icons.close))),
                onChanged: (value) {
                  context.read<PeopleNoteCubit>().loadPeopleNoteByLabelAndName(
                      widget.noteLabel.id!, value);
                },
                onFieldSubmitted: (newValue) {
                  searchFocus.unfocus();
                },
              ),
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
                  if (state.subPeoples == null || state.subPeoples!.isEmpty) {
                    return EmptyDataWidget();
                  }
                  return ListView.builder(
                    itemCount: state.subPeoples!.length,
                    itemBuilder: (context, index) {
                      return PeopleNoteWidget.basic(
                        value: state.subPeoples![index],
                        onTap: () {
                          AppRouter.navigateToInformationPeopleNote(context,
                              peopleNote: state.subPeoples![index]);
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.navigateToCreateNewPeopleNote(context,
              idLabel: widget.noteLabel.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> _deleteNoteLabel(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.are_you_sure_you_want_to_delete),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<NoteLabelCubit>()
                    .deleteNoteLabel(widget.noteLabel.id!)
                    .then((value) {
                  context.read<PeopleNoteCubit>().loaded();
                  Navigator.pop(context);
                  AppRouter.navigateToHome(context);
                });
              },
              child: Text(AppLocalizations.of(context)!.ok),
            )
          ]),
    );
  }

  Future<dynamic> _updateRenameNoteLabel(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => _UpdateNameDialog(
              noteLabel: widget.noteLabel,
            ));
  }

  Future<dynamic> _updateColorNoteLabel(BuildContext context) async {
    Color colorChanged = colorLabel ??
        Theme.of(context).textTheme.displayLarge?.color ??
        Colors.white;
    if (await colorPickerDialog(
        onColorChanged: (p0) {
          colorChanged = p0;
        },
        initColor: colorChanged,
        context: context,
        constraints: const BoxConstraints(minHeight: 200, minWidth: 200))) {
      setState(() {
        colorLabel = colorChanged;
        widget.noteLabel.color = colorLabel?.value;
        context.read<NoteLabelCubit>().updateNoteLabel(widget.noteLabel);
      });
    }
  }
}

// ignore: must_be_immutable
class _UpdateNameDialog extends StatefulWidget {
  _UpdateNameDialog({required this.noteLabel});
  NoteLabel noteLabel;
  @override
  State<_UpdateNameDialog> createState() => __UpdateNameDialogState();
}

class __UpdateNameDialogState extends State<_UpdateNameDialog> {
  final renameEditingController = TextEditingController();
  final renameFocus = FocusNode();
  String? errorNewName;
  @override
  void initState() {
    super.initState();
    renameEditingController.text = widget.noteLabel.name.toString();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(renameFocus);

    return AlertDialog(
        title: Text(AppLocalizations.of(context)!
            .enter_the_new_name_you_want_to_change),
        content: TextFormField(
          controller: renameEditingController,
          focusNode: renameFocus,
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                errorNewName =
                    AppLocalizations.of(context)!.please_enter_the_new_name;
              } else {
                errorNewName = null;
              }
            });
          },
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enter_the_new_name,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            errorText: errorNewName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              renameFocus.unfocus();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              if (errorNewName != null) {
                return;
              }
              renameFocus.unfocus();
              setState(() {
                widget.noteLabel.name = renameEditingController.text;
                context
                    .read<NoteLabelCubit>()
                    .updateNoteLabel(widget.noteLabel);
              });
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.ok),
          )
        ]);
  }
}
