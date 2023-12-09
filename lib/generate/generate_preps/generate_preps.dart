//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '../../_internal_dependencies.dart';

const _R = r"<<<((.+)\|\|)? *([\w-&]+)>>>";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generatePreps({
  Set<String> rootPaths = const {},
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
  List<String? Function(String, String?)> prepMappers = const [],
}) async {
  final combinedPaths = combinePaths([rootPaths, subPaths]);
  for (final path in combinedPaths) {
    final files = await findDartFiles(path, pathPatterns: pathPatterns);
    for (final file in files) {
      final filePath = file.$3;
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
    final localFilePath = toLocalPathFormat(filePath);
    final file = File(localFilePath);
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
                  .replaceAll("&F", localFilePath)
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

extension Prep on String {
  String get prepValue {
    final m = RegExp(_R).firstMatch(this)?[3];
    if (m != null) {
      return m;
    }
    return "";
  }
}
