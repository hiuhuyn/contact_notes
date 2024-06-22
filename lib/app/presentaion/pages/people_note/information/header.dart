import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:contact_notes/app/presentaion/widgets/errors/no_image.dart';
import 'package:contact_notes/core/router/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HeaderInformaionPeople extends StatefulWidget {
  HeaderInformaionPeople(
      {super.key, required this.photos, this.height, this.onTapImageEmpty});
  List<String>? photos;
  double? height;
  Function()? onTapImageEmpty;

  @override
  State<HeaderInformaionPeople> createState() => _HeaderInformaionPeopleState();
}

class _HeaderInformaionPeopleState extends State<HeaderInformaionPeople> {
  @override
  void initState() {
    super.initState();
    widget.photos ??= [];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      height: widget.height,
      curve: Curves.fastEaseInToSlowEaseOut,
      margin: const EdgeInsets.only(bottom: 16),
      child: widget.photos != null && widget.photos!.isNotEmpty
          ? CarouselSlider.builder(
              itemCount: widget.photos!.length,
              itemBuilder: (context, index, realIndex) {
                try {
                  final filePhoto = File(widget.photos![index]);
                  if (widget.photos![index].isEmpty) {
                    throw Exception(
                        "No photos, length: ${widget.photos!.length}");
                  }
                  return GestureDetector(
                    onTap: () {
                      AppRouter.navigateToPhotos(
                        context,
                        photos: widget.photos!,
                        startIndex: index,
                        onDelete: (value) {
                          setState(() {
                            widget.photos!.removeWhere(
                              (element) => element == value,
                            );
                          });
                        },
                      );
                    },
                    child: Container(
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
                    ),
                  );
                } catch (e) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        "Failed to load image\nPath: ${widget.photos![index]}\nError: $e"),
                  );
                }
              },
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 0.8,
                enableInfiniteScroll: false,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
              ),
            )
          : GestureDetector(
              onTap: widget.onTapImageEmpty,
              child: NoImageWidget(
                height: widget.height != null ? widget.height! * 0.8 : null,
                width: MediaQuery.of(context).size.width,
              ),
            ),
    );
  }
}
