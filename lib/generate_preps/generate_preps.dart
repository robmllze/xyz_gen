// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateReflections({
  Set<String> rootPaths = const {},
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  final combinedPaths = combinePaths([rootPaths, subPaths]);
  for (final path in combinedPaths) {
    final files = await findDartFiles(path, pathPatterns: pathPatterns);
    for (final file in files) {
      final filePath = file.$3;
      await generateReflection(filePath);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateReflection(
  String filePath, {
  List<String? Function(String)> prepMappers = const [],
}) async {
  final lines = await readFileLines(filePath);
  if (lines != null) {
    for (var l = 0; l < lines.length; l++) {
      final line = lines[l];
      final a = RegExp(r"<# *([\w-]+) *(= *[\w-,]+)? *>");
      a.allMatches(line).forEach((final match) {
        final c = match.start;
        final c1 = match.end;
        final value = match.group(0);
        if (value != null) {
          final word = match.group(1);
          if (word != null) {
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
              result
                  .replaceAll("l", l.toString())
                  .replaceAll("c", c.toString())
                  .replaceAll("F", filePath.toString())
                  .replaceAll("f", f.toString())
                  .replaceAll("l", l.toString());
            }
            lines[l].replaceRange(c, c1, "<#$word=$result>");
          }
        }
      });
    }
  }
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
