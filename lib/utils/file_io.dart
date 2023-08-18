// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:io';
import 'helpers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<String?> readFile(String filePath) async {
  try {
    final file = File(getFixedPath(filePath));
    final data = await file.readAsString();
    return data;
  } catch (_) {
    return null;
  }
}

Future<void> writeFile(
  String filePath,
  String content, {
  bool append = false,
}) async {
  final file = File(getFixedPath(filePath));
  await file.writeAsString(
    content,
    mode: append ? FileMode.append : FileMode.write,
  );
}

Future<void> clearFile(String filePath) async {
  final file = File(getFixedPath(filePath));
  await file.writeAsString("");
}

Future<void> deleteFile(String filePath) async {
  final file = File(getFixedPath(filePath));
  await file.delete();
}
