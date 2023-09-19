// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generatePreps({
  Set<String> rootPaths = const {},
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  final combinedPaths = combinePaths([rootPaths, subPaths]);
  for (final path in combinedPaths) {
    final files = await findDartFiles(path, pathPatterns: pathPatterns);
    for (final file in files) {
      final filePath = file.$3;
      await _generatePrep(filePath);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generatePrep(
  String filePath, {
  List<String? Function(String)> prepMappers = const [],
}) async {
  try {
    final localFilePath = toLocalPathFormat(filePath);
    final file = File(localFilePath);
    final lines = await file.readAsLines();
    var changed = false;
    for (var l = 0; l < lines.length; l++) {
      final line = lines[l];
      RegExp(r"<# *([\w-]+) *(= *[\w-,.//\/]+)? *>").allMatches(line).forEach((final match) {
        final c = match.start;
        final c1 = match.end;
        final value = match.group(0);
        if (value != null) {
          final word = match.group(1);
          if (word != null && word.isNotEmpty) {
            var result = "";
            if (word.startsWith("_")) {
              for (final prepMapper in prepMappers) {
                final temp = prepMapper(word);
                if (temp != null) {
                  result = temp;
                  break;
                }
              }
            } else {
              final f = getBaseName(filePath);
              result = word
                  .replaceAll("l", l.toString())
                  .replaceAll("c", c.toString())
                  .replaceAll("F", localFilePath)
                  .replaceAll("f", f);
            }
            final before = lines[l];
            final after = lines[l].replaceRange(c, c1, "<#$word=$result>");
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
  String get prep {
    final m = RegExp(r"<# *([\w-]+) *(= *[\w-,]+)? *>").firstMatch(this)?[2];
    if (m != null) {
      return m;
    }
    return "";
  }
}
