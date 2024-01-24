//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';
import 'package:path/path.dart' as p;

import '/xyz_utils/all_xyz_utils.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<String?> readFile(String filePath) async {
  try {
    final file = File(toLocalPathFormat(filePath));
    final data = await file.readAsString();
    return data;
  } catch (_) {
    return null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<List<String>?> readFileAsLines(String filePath) async {
  try {
    final file = File(toLocalPathFormat(filePath));
    final lines = await file.readAsLines();
    return lines;
  } catch (_) {
    return null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> writeFile(
  String filePath,
  String content, {
  bool append = false,
}) async {
  final file = File(toLocalPathFormat(filePath));
  await file.parent.create(recursive: true);
  await file.writeAsString(
    content,
    mode: append ? FileMode.append : FileMode.write,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> clearFile(String filePath) async {
  final file = File(toLocalPathFormat(filePath));
  await file.writeAsString("");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> deleteFile(String filePath) async {
  final file = File(toLocalPathFormat(filePath));
  await file.delete();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<bool> fileExists(String filePath) {
  return File(toLocalPathFormat(filePath)).exists();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<File?> findFileByName(String fileName, String directoryPath) async {
  final directory = Directory(directoryPath);
  if (!await directory.exists()) return null;
  final entities = directory.listSync(recursive: true);
  for (final entity in entities) {
    if (entity is File && entity.path.endsWith('/$fileName')) {
      return entity;
    }
  }
  return null;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<List<String>?> listFilePaths(
  String dirPath, {
  bool recursive = true,
}) async {
  final dir = Directory(toLocalPathFormat(dirPath));
  final filePaths = <String>[];
  if (await dir.exists()) {
    final entities = dir.listSync(recursive: recursive);
    for (final entity in entities) {
      if (entity is File) {
        filePaths.add(entity.path);
      }
    }
  } else {
    return null;
  }
  return filePaths;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String getDesktopPath() {
  try {
    if (Platform.isMacOS) {
      return p.join("Users", Platform.environment["USER"]!, "Desktop");
    } else if (Platform.isWindows) {
      return p.join(Platform.environment["USERPROFILE"]!, "Desktop");
    } else if (Platform.isLinux) {
      return p.join("home", Platform.environment["USER"]!, "Desktop");
    } else {
      throw false;
    }
  } catch (_) {
    throw UnsupportedError("Unsupported platform");
  }
}
