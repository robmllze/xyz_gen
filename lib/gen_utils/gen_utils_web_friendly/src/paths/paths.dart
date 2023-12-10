//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Determines if the given file path refers to a Dart file, optionally filtered
/// by path patterns.
bool isDartFilePath(
  String filePath, [
  Set<String> pathPatterns = const {},
]) {
  final a =
      pathPatterns.isEmpty || pathContainsPatterns(filePath, pathPatterns);
  final b = filePath.toLowerCase().endsWith(".dart");
  final c = a && b;
  return c;
}

/// Determines if the given file path refers to a Dart source file
/// (not generated), optionally filtered by path patterns.
bool isSourceDartFilePath(
  String filePath, [
  Set<String> pathPatterns = const {},
]) {
  final lowerCasefilePath = filePath.toLowerCase();
  final a =
      pathPatterns.isEmpty || pathContainsPatterns(filePath, pathPatterns);
  final b = lowerCasefilePath.endsWith(".dart");
  final c = lowerCasefilePath.endsWith(".g.dart");
  return a && b && !c;
}

/// Determines if the given file path refers to a Dart file generated by code
/// generators.
bool isGeneratedDartFilePath(
  String filePath, [
  Set<String> pathPatterns = const {},
]) {
  final a =
      pathPatterns.isEmpty || pathContainsPatterns(filePath, pathPatterns);
  final b = filePath.toLowerCase().endsWith(".g.dart");
  final c = a && b;
  return c;
}

/// Returns the associated source Dart file path of a generated Dart file or
/// null if not a Dart file (the file path without the ".g" if present).
String? getSourcePath(String filePath) {
  final fixedPath = toLocalPathFormat(filePath);
  final dirName = p.dirname(fixedPath);
  final baseName = p.basename(fixedPath);
  if (baseName.endsWith(".g.dart")) {
    return p.join(
      dirName,
      "${baseName.substring(0, baseName.length - ".g.dart".length)}.dart",
    );
  }
  if (baseName.endsWith(".dart")) {
    return fixedPath;
  }
  return null;
}

/// Returns the base name of a given file path.
String getBaseName(String path) => p.basename(toLocalPathFormat(path));

/// Returns the directory path of a given file path.
String getDirPath(String path) => p.dirname(toLocalPathFormat(path));

/// Checks if the provided path contains any of the specified components.
bool pathContainsComponent(String path, Set<String> components) {
  final fixedPath = toLocalPathFormat(path);
  final a = p.split(fixedPath);
  for (final component in components) {
    if (a.contains(component.toLowerCase())) {
      return true;
    }
  }
  return false;
}

/// Checks if the provided path matches any of the specified path patterns.
bool pathContainsPatterns(String path, Set<String> pathPatterns) {
  final fixedPath = toLocalPathFormat(path);
  for (final pattern in pathPatterns) {
    if (RegExp(pattern).hasMatch(fixedPath)) return true;
  }
  return false;
}

/// Converts the given path to a consistent, local path format.
String getFileNameWithoutExtension(String filePath) {
  return p.basenameWithoutExtension(toLocalPathFormat(filePath));
}

/// Converts the given path to a consistent, local path format.
String toLocalPathFormat(String path) {
  return path.split(RegExp(r"[\\/]")).join(p.separator).toLowerCase();
}

/// Checks if the provided file is a private Dart file (starts with an
/// underscore).
bool isPrivateFileName(String filePath) {
  final fileName = getBaseName(filePath);
  return fileName.startsWith("_");
}

/// Checks if the file name matches the specified beginning and ending types.
/// Returns a tuple with the match status and the file name.
(bool, String) isMatchingFileName(
  String filePath,
  String begType,
  String endType,
) {
  final fileName = getBaseName(filePath);
  final a =
      begType.isEmpty ? true : fileName.startsWith("${begType.toLowerCase()}_");
  final b =
      endType.isEmpty ? true : fileName.endsWith(".$endType".toLowerCase());
  final c = a && b;
  return (c, fileName);
}

/// Extracts nested scopes from a source string based on opening and closing delimiters.
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
