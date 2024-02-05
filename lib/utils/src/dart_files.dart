//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:xyz_utils/shared/all_shared.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Formats the dart file at [filePath].
Future<void> fmtDartFile(String filePath) async {
  try {
    final localFilePath = toLocalSystemPathFormat(filePath);
    await Process.run("dart", ["format", localFilePath]);
  } catch (_) {}
}

/// Applies fixes to the dart file at [filePath].
Future<void> fixDartFile(String filePath) async {
  try {
    final localFilePath = toLocalSystemPathFormat(filePath);
    await Process.run("dart", ["fix", "--apply", localFilePath]);
  } catch (_) {}
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Finds all the dart files in [rootDirPath] and its sub-directories
Future<List<DartFileResult>> findDartFiles(
  String rootDirPath, {
  Set<String> pathPatterns = const {},
  Future<bool> Function(
    String dirPath,
    String folderName,
    String filePath,
  )? onFileFound,
}) async {
  final results = <DartFileResult>[];
  final filePaths = await listFilePaths(rootDirPath);
  if (filePaths != null) {
    filePaths.sort();
    for (final filePath in filePaths) {
      if (isDartFilePath(filePath) && matchesAnyPathPattern(filePath, pathPatterns)) {
        final dirPath = getDirPath(filePath);
        final folderName = getBaseName(dirPath);
        final add = (await onFileFound?.call(dirPath, folderName, filePath)) ?? true;
        if (add) {
          final result = DartFileResult(
            dirPath: dirPath,
            folderName: folderName,
            filePath: filePath,
          );
          results.add(result);
        }
      }
    }
  }
  return results;
}

/// Finds all the generated dart files in [rootDirPath] and its sub-directories.
Future<List<DartFileResult>> findGeneratedDartFiles(
  String rootDirPath, {
  Set<String> pathPatterns = const {},
  Future<bool> Function(
    String dirPath,
    String folderName,
    String filePath,
  )? onFileFound,
}) async {
  final results = <DartFileResult>[];
  final filePaths = await listFilePaths(rootDirPath);
  if (filePaths != null) {
    filePaths.sort();
    for (final filePath in filePaths) {
      if (isGeneratedDartFilePath(filePath)) {
        final dirPath = getDirPath(filePath);
        final folderName = getBaseName(dirPath);
        final add = (await onFileFound?.call(dirPath, folderName, filePath)) ?? true;
        if (add) {
          final result = DartFileResult(
            dirPath: dirPath,
            folderName: folderName,
            filePath: filePath,
          );
          results.add(result);
        }
      }
    }
  }
  return results;
}

class DartFileResult {
  final String dirPath;
  final String folderName;
  final String filePath;
  const DartFileResult({
    required this.dirPath,
    required this.folderName,
    required this.filePath,
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Returns the associated source Dart file path of a generated Dart file or
/// null if not a Dart file (the file path without the ".g" if present).
String? getSourcePath(String filePath) {
  final localSystemFilePath = toLocalSystemPathFormat(filePath);
  final dirName = p.dirname(localSystemFilePath);
  final baseName = p.basename(localSystemFilePath);
  if (baseName.endsWith(".g.dart")) {
    return p.join(
      dirName,
      "${baseName.substring(0, baseName.length - ".g.dart".length)}.dart",
    );
  }
  if (baseName.endsWith(".dart")) {
    return localSystemFilePath;
  }
  return null;
}

/// Whether [filePath] ends with ".dart".
bool isDartFilePath(String filePath) {
  return filePath.toLowerCase().endsWith(".dart");
}

/// Whether [filePath] ends with ".g.dart".
bool isGeneratedDartFilePath(String filePath) {
  return filePath.toLowerCase().endsWith(".g.dart");
}

/// Whether [filePath] ends with ".dart" and does not end with ".g.dart".
bool isSourceDartFilePath(String filePath) {
  return isDartFilePath(filePath) && !isGeneratedDartFilePath(filePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Reads all Dart code snippets from a markdown file.
///
/// Searches for blocks of Dart code in the markdown file, demarcated by
/// "```dart" at the beginning and "```" at the end of each block. Each Dart
/// code block is extracted and returned as a separate string within a list.
///
/// The function expects a file path to a markdown file.
///
/// [filePath] The path to the markdown file.
/// Returns a Future that resolves to a list of strings, each containing a Dart
/// code block.
Future<List<String>> readDartSnippetsFromMarkdownFile(String filePath) async {
  final isMarkdownFile = filePath.toLowerCase().endsWith(".md");
  if (!isMarkdownFile) {
    throw Exception("Not a Markdown file: $filePath");
  }
  final file = File(filePath);
  final input = await file.readAsString();
  final dartCodeRegex = RegExp(r"```dart(.*?)```", dotAll: true);
  final matches = dartCodeRegex.allMatches(input);
  return matches.map((match) => match.group(1)?.trim() ?? "").toList();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Deletes the .g.dart file at [filePath].
Future<void> deleteGeneratedDartFile(
  String filePath, {
  void Function(String filePath)? onDelete,
  Set<String> pathPatterns = const {},
}) async {
  if (isGeneratedDartFilePath(filePath) && matchesAnyPathPattern(filePath, pathPatterns)) {
    await deleteFile(filePath);
    onDelete?.call(filePath);
  }
}

/// Deletes all the .g.dart files form [dirPath] and its sub-directories.
Future<void> deleteGeneratedDartFiles(
  String dirPath, {
  void Function(String filePath)? onDelete,
  Set<String> pathPatterns = const {},
}) async {
  final filePaths = await listFilePaths(dirPath);
  if (filePaths != null) {
    for (final filePath in filePaths) {
      await deleteGeneratedDartFile(
        filePath,
        onDelete: onDelete,
        pathPatterns: pathPatterns,
      );
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Whether the source and generated Dart files exist for [filePath].
Future<bool> sourceAndGeneratedDartFileExists(
  String filePath, [
  Set<String> pathPatterns = const {},
]) async {
  if (matchesAnyPathPattern(filePath, pathPatterns)) {
    if (isSourceDartFilePath(filePath)) {
      final a = await fileExists(filePath);
      final b = await fileExists(
        "${filePath.substring(0, filePath.length - ".dart".length)}.g.dart",
      );
      return a && b;
    }
    if (isGeneratedDartFilePath(filePath)) {
      final a = await fileExists(filePath);
      final b = await fileExists(
        "${filePath.substring(0, filePath.length - ".g.dart".length)}.dart",
      );
      return a && b;
    }
  }
  return false;
}
