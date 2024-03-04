//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// X|Y|Z & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Formats the dart file at `filePath`.
Future<void> fmtDartFile(String filePath) async {
  try {
    final localFilePath = toLocalSystemPathFormat(filePath);
    await Process.run("dart", ["format", localFilePath]);
  } catch (_) {}
}

/// Applies fixes to the dart file at `filePath`.
Future<void> fixDartFile(String filePath) async {
  try {
    final localFilePath = toLocalSystemPathFormat(filePath);
    await Process.run("dart", ["fix", "--apply", localFilePath]);
  } catch (_) {}
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Finds all the dart files in `rootDirPath` and its sub-directories.
Future<List<FindFileResult>> findFiles(
  String rootDirPath, {
  Set<String> extensions = const {},
  Set<String> pathPatterns = const {},
  Future<bool> Function(
    String dirPath,
    String folderName,
    String filePath,
  )? onFileFound,
}) async {
  final results = <FindFileResult>[];
  final filePaths = await listFilePaths(rootDirPath);
  if (filePaths != null) {
    filePaths.sort();
    for (final filePath in filePaths) {
      if (matchesAnyExtensions(filePath, extensions) &&
          matchesAnyPathPattern(filePath, pathPatterns)) {
        final dirPath = getDirPath(filePath);
        final folderName = getBaseName(dirPath);
        final add =
            (await onFileFound?.call(dirPath, folderName, filePath)) ?? true;
        if (add) {
          final result = FindFileResult(
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

/// Finds all the generated dart files in `rootDirPath` and its sub-directories.
Future<List<FindFileResult>> findGeneratedDartFiles(
  String rootDirPath, {
  Set<String> pathPatterns = const {},
  Future<bool> Function(
    String dirPath,
    String folderName,
    String filePath,
  )? onFileFound,
}) async {
  final results = <FindFileResult>[];
  final filePaths = await listFilePaths(rootDirPath);
  if (filePaths != null) {
    filePaths.sort();
    for (final filePath in filePaths) {
      if (isGeneratedDartFilePath(filePath)) {
        final dirPath = getDirPath(filePath);
        final folderName = getBaseName(dirPath);
        final add =
            (await onFileFound?.call(dirPath, folderName, filePath)) ?? true;
        if (add) {
          final result = FindFileResult(
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

/// The result of a `findFiles` or `findGeneratedDartFiles` operation.
class FindFileResult {
  final String dirPath;
  final String folderName;
  final String filePath;

  const FindFileResult({
    required this.dirPath,
    required this.folderName,
    required this.filePath,
  });

  String get extension => p.extension(filePath);
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

/// Whether `filePath` ends with ".dart".
bool isDartFilePath(String filePath) {
  return filePath.toLowerCase().endsWith(".dart");
}

/// Whether `filePath` ends with ".g.dart".
bool isGeneratedDartFilePath(String filePath) {
  return filePath.toLowerCase().endsWith(".g.dart");
}

/// Whether `filePath` ends with `extension`.
bool matchesAnyExtensions(
  String filePath,
  Set<String> extensions, {
  bool caseSensitive = true,
}) {
  if (extensions.isEmpty) return true;
  final extension = p.extension(filePath);
  return extensions.any((e) {
    final a = caseSensitive ? extension : extension.toLowerCase();
    final b = caseSensitive ? e : e.toLowerCase();
    return a == b;
  });
}

/// Whether `filePath` ends with ".dart" and does not end with ".g.dart".
bool isSourceDartFilePath(String filePath) {
  return isDartFilePath(filePath) && !isGeneratedDartFilePath(filePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Reads all code snippets from a markdown file.
///
/// ### Parameters:
///
/// - `filePath`: The path to the markdown file.
/// - `lang`: The language code, i.e. "dart" for Dart-code snippets, `yaml` for
///   YAML-code snippets or "[^\\n]+" for any language.
///
/// ### Returns:
///
/// - A Future of list of code snippets.
Future<List<String>> readSnippetsFromMarkdownFile(
  String filePath, {
  String lang = "[^\\n]+",
}) async {
  final isMarkdownFile = filePath.toLowerCase().endsWith(".md");
  if (!isMarkdownFile) {
    throw Exception("Not a Markdown file: $filePath");
  }
  final file = File(filePath);
  final input = await file.readAsString();
  final dartCodeRegex = RegExp("````($lang)\\n(.*?)````", dotAll: true);
  final matches = dartCodeRegex.allMatches(input);
  return matches.map((match) => match.group(2)?.trim() ?? "").toList();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Deletes the .g.dart file at `filePath`.
Future<void> deleteGeneratedDartFile(
  String filePath, {
  void Function(String filePath)? onDelete,
  Set<String> pathPatterns = const {},
}) async {
  if (isGeneratedDartFilePath(filePath) &&
      matchesAnyPathPattern(filePath, pathPatterns)) {
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

/// Whether the source and generated Dart files exist for `filePath`.
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
