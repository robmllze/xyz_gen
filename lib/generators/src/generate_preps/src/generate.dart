//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

import '/utils/src/dart_files.dart';
import '/utils/all_utils.g.dart';
import 'package:xyz_utils/shared/all_shared.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _R = r"<<<((.+)\|\|)? *([\w-&]+)>>>";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generatePreps({
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  List<String? Function(String, String?)> prepMappers = const [],
}) async {
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    final results = await findDartFiles(dirPath, pathPatterns: pathPatterns);
    for (final result in results) {
      final filePath = result.filePath;
      await _generatePrep(filePath, prepMappers);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generatePrep(
  String filePath,
  List<String? Function(String, String?)> prepMappers,
) async {
  try {
    final file = File(filePath);
    final lines = await file.readAsLines();
    var changed = false;
    for (var l = 0; l < lines.length; ++l) {
      final line = lines[l];
      RegExp(_R).allMatches(line).forEach((final match) {
        final c = match.start;
        final c1 = match.end;
        final chunk = match.group(0);
        if (chunk != null) {
          var result = "";
          final key = match.group(3);
          if (key != null && key.isNotEmpty) {
            if (key.startsWith("&&")) {
              final rawKey = key.replaceFirst("&&", "");
              final value = match.group(2);
              for (final prepMapper in prepMappers) {
                final temp = prepMapper(rawKey, value);
                if (temp != null) {
                  result = temp;
                  break;
                }
              }
            } else {
              final f = getBaseName(filePath);
              result = key
                  .replaceAll("&l", l.toString())
                  .replaceAll("&c", c.toString())
                  .replaceAll("&F", filePath)
                  .replaceAll("&f", f);
            }
            final before = lines[l];
            final after = lines[l].replaceRange(c, c1, "<<<$result||$key>>>");
            changed = changed || before != after;
            if (changed) {
              lines[l] = after;
            }
          }
        }
      });
    }
    if (changed) {
      await file.writeAsString(lines.join("\n"));
      printGreen("File updated: $filePath");
    }
  } catch (_) {}
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension PrepOnStringExtension on String {
  String get prepValue {
    final m = RegExp(_R).firstMatch(this)?[3];
    if (m != null) {
      return m;
    }
    return "";
  }
}
