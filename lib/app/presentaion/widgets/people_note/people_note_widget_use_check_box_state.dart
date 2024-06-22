import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/usecases/note_label/get_note_label_by_id.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/setup.dart';

class PeopleNoteWidgetUseCheckBoxState extends State<PeopleNoteWidget> {
  final controller = TextEditingController();
  final focusDesc = FocusNode();
  bool isCheck = false;
  NoteLabel? noteLabel;
  bool isCheckFilePhoto = false;

  @override
  void initState() {
    super.initState();
    controller.text = widget.initDescription ?? "";
    focusDesc.addListener(() {
      if (!focusDesc.hasFocus && widget.onFieldSubmittedDescription != null) {
        widget.onFieldSubmittedDescription!(controller.text);
      }
    });
    isCheck = widget.initValueCheck;
    if (widget.value.idLabel != null) {
      sl<GetNoteLabelById>().call(widget.value.idLabel!).then(
        (value) {
          if (value is DataSuccess) {
            if (mounted) {
              setState(() {
                noteLabel = value.data;
              });
            }
          }
        },
      );
    }
    if (widget.value.photos != null && widget.value.photos!.isNotEmpty) {
      File(widget.value.photos!.first).exists().then(
        (value) {
          if (mounted) {
            setState(() {
              isCheckFilePhoto = value;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              offset: const Offset(0, 1),
              blurRadius: 5,
              spreadRadius: 0.5,
            ),
          ],
          border: Border.all(width: 0, color: Colors.transparent),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noteLabel != null && noteLabel!.name != null)
              Row(
                children: [
                  Icon(
                    Icons.label_outline_rounded,
                    color: noteLabel!.color != null
                        ? Color(noteLabel!.color!)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    noteLabel!.name.toString(),
                  ),
                ],
              ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCheck = !isCheck;
                    });
                    if (widget.onCheckBoxChanged != null) {
                      widget.onCheckBoxChanged!(isCheck);
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: isCheck ? const Icon(Icons.check) : null,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    backgroundColor: widget.value.isMale == true
                        ? Colors.blue.shade200
                        : Colors.pink.shade200,
                    backgroundImage: isCheckFilePhoto &&
                            widget.value.photos != null &&
                            widget.value.photos!.isNotEmpty
                        ? FileImage(File(widget.value.photos!.first))
                        : null,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.value.name != null &&
                            widget.value.name!.isNotEmpty)
                          Text(
                            widget.value.name ?? "",
                            maxLines: 1,
                          ),
                        Text(DateFormat('EEE, dd/MM/yyyy')
                            .format(widget.value.created ?? DateTime.now())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (widget.value.address != null &&
                widget.value.address!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  Text(
                    "${widget.value.address}",
                  ),
                ],
              ),
            if (widget.onFieldSubmittedDescription != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onDoubleTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: TextFormField(
                    scrollPadding: const EdgeInsets.all(5),
                    controller: controller,
                    focusNode: focusDesc,
                    onFieldSubmitted: widget.onFieldSubmittedDescription,
                    decoration: InputDecoration(
                      hintText: 'Descripsion',
                      suffixIcon: IconButton(
                          onPressed: () {
                            widget
                                .onFieldSubmittedDescription!(controller.text);
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.check)),
                    ),
                    maxLines: null,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
