import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_state.dart';
import 'package:contact_notes/app/presentaion/widgets/app_drawer.dart';
import 'package:contact_notes/app/presentaion/widgets/errors/empty_data.dart';
import 'package:contact_notes/core/router/app_router.dart';
import 'package:contact_notes/core/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/*
  create a new note tag
  show the note tag
*/
// ignore: must_be_immutable
class NoteLabelScreen extends StatefulWidget {
  NoteLabelScreen({super.key, required this.selectNewLabel});
  bool selectNewLabel;

  @override
  State<NoteLabelScreen> createState() => _NoteLabelScreenState();
}

class _NoteLabelScreenState extends State<NoteLabelScreen> {
  final focusNode = FocusNode();
  final textEditingController = TextEditingController();
  String? errorNewLabel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.label),
      ),
      drawer: AppDrawer(
        tag: DrawerTag.noteLabel,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          errorNewLabel = null;
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<NoteLabelCubit, NoteLabelState>(
                builder: (context, state) {
                  if (state is NoteLabelInitialState) {
                    return const SizedBox();
                  }
                  if (state is NoteLabelLoadingState) {
                    return const ListTile(title: CircularProgressIndicator());
                  }
                  if (state is NoteLabelErrorState) {
                    return Text(
                      state.error!.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  if (state.notes != null && state.notes!.isEmpty) {
                    return EmptyDataWidget();
                  }
                  return ListView.builder(
                    itemCount: state.notes!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            AppRouter.navigateToNoteTag(context,
                                noteLabel: state.notes![index]);
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.label_important_outline,
                              color: state.notes![index].color != null
                                  ? Color(state.notes![index].color!)
                                  : null,
                            ),
                            title: Text(state.notes![index].name!),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30, right: 8, left: 8),
              decoration: BoxDecoration(
                border: Border.all(
                    color: errorNewLabel != null ? Colors.red : Colors.grey,
                    width: 1),
                borderRadius: BorderRadius.circular(45),
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (focusNode.hasFocus) {
                          focusNode.unfocus();
                        } else {
                          FocusScope.of(context).requestFocus(focusNode);
                        }
                        textEditingController.clear();
                      },
                      icon: Icon(focusNode.hasFocus ? Icons.close : Icons.add)),
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: textEditingController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            errorNewLabel = AppLocalizations.of(context)!
                                .please_enter_a_label;
                          });
                        } else {
                          setState(() {
                            errorNewLabel = null;
                          });
                        }
                      },
                      onFieldSubmitted: (newValue) {
                        _createNewLabel(context);
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.new_label,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _createNewLabel(context);
                      },
                      icon: const Icon(Icons.check)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createNewLabel(BuildContext context) {
    if (textEditingController.text.isEmpty) {
      setState(() {
        errorNewLabel = AppLocalizations.of(context)!.please_enter_a_label;
      });
    } else {
      final newLabel = NoteLabel(
          id: generateId(FirebaseAuth.instance.currentUser!.uid.toString(),
              textEditingController.text),
          name: textEditingController.text);
      context.read<NoteLabelCubit>().createNoteLabel(newLabel);
      setState(() {
        errorNewLabel = null;
        textEditingController.text = "";
        focusNode.unfocus();
      });
    }
  }
}
