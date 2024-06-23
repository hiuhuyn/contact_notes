import 'dart:convert';

import 'package:contact_notes/core/exceptions/custom_exception.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

String generateId(String userId, String input) {
  // Chuyển chuỗi sang bytes
  var bytes = utf8.encode(input);

  // Tạo băm SHA-256 từ bytes
  var digest = sha256.convert(bytes);

  final String formattedTime = DateTime.now().millisecondsSinceEpoch.toString();

  final String generatedId = '$formattedTime-$userId-$digest';

  return generatedId.replaceAll(' ', '');
}

Future<void> showLoadingWithFuture(BuildContext ctx, Future futureTask,
    {Function()? onLoadSuccess, Function(dynamic value)? onLoadFailed}) async {
  showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) {
        futureTask.then(
          (value) {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            if (value is DataFailed) {
              if (onLoadFailed != null) {
                onLoadFailed(value);
              } else {
                showDiaLogError(ctx, value.error!);
              }
            } else {
              if (onLoadSuccess != null) {
                onLoadSuccess();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Loading thanh cong")));
              }
            }
          },
        );

        return const Center(child: CircularProgressIndicator());
      });
}

Future showDiaLogError(BuildContext ctx, CustomException error) async {
  return showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: error.title != null ? Text("Error: ${error.title}") : null,
        content: Text(error.message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
