import 'dart:convert';

import 'package:crypto/crypto.dart';

String generateId(String userId, String input) {
  // Chuyển chuỗi sang bytes
  var bytes = utf8.encode(input);

  // Tạo băm SHA-256 từ bytes
  var digest = sha256.convert(bytes);

  final String formattedTime = DateTime.now().millisecondsSinceEpoch.toString();

  final String generatedId = '$formattedTime-$userId-$digest';

  return generatedId.replaceAll(' ', '');
}
