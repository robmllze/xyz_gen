// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:io';

import 'package:path/path.dart' as p;

import 'file_io.dart';
import 'list_file_paths.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> deleteGeneratedFiles(
  String dirPath, [
  Set<String> pathPatterns = const {},
]) async {
  final filePaths = await listFilePaths(dirPath);
  if (filePaths != null) {
    for (final filePath in filePaths) {
      final a = pathPatterns.isEmpty || pathContainsPatterns(filePath, pathPatterns);
      final b = isGeneratedDartFilePath(filePath);
      final c = a && b;
      if (c) {
        await deleteFile(filePath);
      }
    }
  }
}

String replaceAllData(String input, Map<Pattern, dynamic> data) {
  var output = input;

  for (final entry in data.entries) {
    final pattern = entry.key;
    final value = entry.value;
    output = output.replaceAll(pattern, value.toString());
  }
  return output;
}

bool isDartFilePath(String filePath) {
  return filePath.toLowerCase().endsWith(".dart");
}

bool isSourceDartFilePath(String filePath) {
  final lowerCasefilePath = filePath.toLowerCase();
  final a = lowerCasefilePath.endsWith(".dart");
  final b = lowerCasefilePath.endsWith(".g.dart");
  return a && !b;
}

bool isGeneratedDartFilePath(String filePath) {
  return filePath.toLowerCase().endsWith(".g.dart");
}

/// The file path without the ".g" if present.
String? getSourcePath(String filePath) {
  final fixedPath = getFixedPath(filePath);
  final dirName = p.dirname(fixedPath);
  final baseName = p.basename(fixedPath);
  if (baseName.endsWith(".g.dart")) {
    return p.join(dirName, "${baseName.substring(0, baseName.length - ".g.dart".length)}.dart");
  }
  if (baseName.endsWith(".dart")) {
    return fixedPath;
  }
  return null;
}

String getBaseName(String path) => p.basename(getFixedPath(path));
String getDirName(String path) => p.dirname(getFixedPath(path));

bool pathContainsComponent(String path, Set<String> components) {
  final fixedPath = getFixedPath(path);
  final a = p.split(fixedPath);
  for (final component in components) {
    if (a.contains(component.toLowerCase())) {
      return true;
    }
  }
  return false;
}

bool pathContainsPatterns(String path, Set<String> pathPatterns) {
  final fixedPath = getFixedPath(path);
  for (final pattern in pathPatterns) {
    if (RegExp(pattern).hasMatch(fixedPath)) return true;
  }
  return false;
}

String getFileNameWithoutExtension(String filePath) {
  return p.basenameWithoutExtension(getFixedPath(filePath));
}

String getFixedPath(String path) {
  return path.split(RegExp(r"[\\/]")).join(p.separator).toLowerCase();
}

bool isPrivateFile(String filePath) {
  final fileName = getBaseName(filePath);
  return fileName.startsWith("_");
}

(bool, String) isCorrectFileName(String filePath, String begType, String endType) {
  final fileName = getBaseName(filePath);
  final a = fileName.startsWith("${begType.toLowerCase()}_");
  final b = fileName.endsWith(".$endType".toLowerCase());
  final c = a && b;
  return (c, fileName);
}

Future<bool> fileExists(String filePath) => File(getFixedPath(filePath)).exists();

Future<bool> sourceAndGeneratedFileExists(String filePath) async {
  if (isSourceDartFilePath(filePath)) {
    final a = await fileExists(filePath);
    final b = await fileExists("${filePath.substring(0, filePath.length - ".dart".length)}.g.dart");
    return a && b;
  }
  if (isGeneratedDartFilePath(filePath)) {
    final a = await fileExists(filePath);
    final b = await fileExists("${filePath.substring(0, filePath.length - ".g.dart".length)}.dart");
    return a && b;
  }
  return false;
}
