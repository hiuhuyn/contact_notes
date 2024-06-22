import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoImageWidget extends StatefulWidget {
  NoImageWidget({
    super.key,
    this.height,
    this.width,
  });
  double? width;
  double? height;

  @override
  State<NoImageWidget> createState() => _NoImageWidgetState();
}

class _NoImageWidgetState extends State<NoImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
          child: Image.asset(
        "assets/icons/no-image.png",
        height: widget.height != null ? widget.height! * 0.8 : null,
        fit: BoxFit.fitHeight,
      )),
    );
  }
}
