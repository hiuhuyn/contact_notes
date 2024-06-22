import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/usecases/note_label/get_note_label_by_id.dart';
import 'package:contact_notes/app/presentaion/blocs/settings/settings_cubit.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/setup.dart';

class PeopleNoteWidgetBasicState extends State<PeopleNoteWidget> {
  NoteLabel? noteLabel;
  bool isCheckFilePhoto = false;

  @override
  void initState() {
    super.initState();
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
    if (widget.value.idLabel != null && widget.value.idLabel != noteLabel?.id) {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
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
              ),
            Row(
              children: [
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    Text("${widget.value.address}"),
                  ],
                ),
              ),
            if (widget.value.desc != null && widget.value.desc!.isNotEmpty)
              Text(
                "${widget.value.desc}",
                maxLines: null,
              ),
            if (context.read<SettingsCubit>().state.isShowPreviewPhotos)
              _prevewPhoto(),
          ],
        ),
      ),
    );
  }

  Widget _prevewPhoto() {
    return Column(
      children: [
        if (isCheckFilePhoto &&
            widget.value.photos != null &&
            widget.value.photos!.length > 1)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            height: 200,
            child: CarouselSlider.builder(
              itemCount: widget.value.photos!.length,
              itemBuilder: (context, index, realIndex) {
                try {
                  final filePhoto = File(widget.value.photos![index]);
                  if (widget.value.photos![index].isEmpty) {
                    throw Exception(
                        "No photos, length: ${widget.value.photos!.length}");
                  }
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(filePhoto),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ]),
                  );
                } catch (e) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        "Failed to load image\nPath: ${widget.value.photos![index]}\nError: $e"),
                  );
                }
              },
              options: CarouselOptions(
                initialPage: widget.value.photos!.length >= 3 ? 1 : 0,
                height: double.infinity,
                viewportFraction: 0.8,
                enableInfiniteScroll: false,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
              ),
            ),
          ),
        if (isCheckFilePhoto &&
            widget.value.photos != null &&
            widget.value.photos!.length == 1)
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
                image: DecorationImage(
                  image: FileImage(
                    File(widget.value.photos!.first),
                  ),
                  fit: BoxFit.cover,
                )),
          )
      ],
    );
  }
}
