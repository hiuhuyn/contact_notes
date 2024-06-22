import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// ignore: must_be_immutable
class PhotosScreen extends StatefulWidget {
  PhotosScreen({
    super.key,
    required this.photos,
    this.isOffline = true,
    this.startIndex = 0,
    this.onDelete,
  });
  List<String> photos;
  bool isOffline;
  int startIndex;
  Function(String value)? onDelete;
  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  int index = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
    pageController = PageController(initialPage: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (widget.onDelete != null && widget.photos.isNotEmpty) {
                setState(() {
                  widget.onDelete!(widget.photos[index]);
                });
              }
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.photos.length,
        pageController: pageController,
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
        },
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(widget.photos[index])),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}
