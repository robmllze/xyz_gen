// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:io';

import 'package:path/path.dart' as p;

import 'file_io.dart';
import 'list_file_paths.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Formats the dart file at [filePath].
Future<void> fmtDartFile(String filePath) async {
  try {
    final fixedPath = getFixedPath(filePath);
    await Process.run("dart", ["format", fixedPath]);
  } catch (e) {
    print(e);
  }
}

/// Deletes all the .g.dart files form [dirPath] and its sub-directories if
/// [dirPath] contains any of the [pathPatterns].
Future<void> deleteGeneratedDartFiles(
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

/// Replaces all the [data] in [input] and returns the output.
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

String getFileName(String path) {
  return p.basename(getFixedPath(path));
}

String getDirPath(String path) {
  return p.dirname(getFixedPath(path));
}

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
  final fileName = getFileName(filePath);
  return fileName.startsWith("_");
}

(bool, String) isMatchingFileName(String filePath, String begType, String endType) {
  final fileName = getFileName(filePath);
  final a = fileName.startsWith("${begType.toLowerCase()}_");
  final b = fileName.endsWith(".$endType".toLowerCase());
  final c = a && b;
  return (c, fileName);
}

Future<bool> fileExists(String filePath) {
  return File(getFixedPath(filePath)).exists();
}

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

List<dynamic> extractScopes(String source, String open, String close) {
  var index = 0;
  dynamic parse() {
    final result = <dynamic>[];
    while (index < source.length) {
      if (source.startsWith(open, index)) {
        index += open.length;
        result.add(parse());
      } else if (source.startsWith(close, index)) {
        index += close.length;
        return result.isNotEmpty ? result : result.first;
      } else {
        final nextOpen = source.indexOf(open, index);
        final nextClose = source.indexOf(close, index);
        var nextIndex = nextOpen;
        if (nextOpen == -1 || (nextClose != -1 && nextClose < nextOpen)) {
          nextIndex = nextClose;
        }
        if (nextIndex == -1) {
          result.add(source.substring(index).trim());
          break;
        } else {
          result.add(source.substring(index, nextIndex).trim());
          index = nextIndex;
        }
      }
    }
    return result.isNotEmpty ? result : null;
  }

  return parse();
}

// ignore: camel_case_extensions
extension String_replaceLast on String {
  String replaceLast(Pattern from, String to, [int startIndex = 0]) {
    final match = from.allMatches(this, startIndex).lastOrNull;
    if (match == null) return this;
    final lastIndex = match.start;
    final beforeLast = this.substring(0, lastIndex);
    final group0 = match.group(0);
    if (group0 == null) return this;
    final afterLast = this.substring(lastIndex + group0.length);
    return beforeLast + to + afterLast;
  }
}
