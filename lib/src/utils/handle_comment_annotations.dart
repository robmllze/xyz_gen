//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> handleCommentAnnotations({
  required String filePath,
  required Map<String, Future<bool> Function(int, List<String>, String)>
      annotationHandlers,
  required Set<String> annotationsToDelete,
}) async {
  final lines = await readFileAsLines(filePath) ?? [];
  if (lines.isNotEmpty) {
    final simplifiedAnnotationHandlers = annotationHandlers.map(
      (k, v) =>
          MapEntry(k.replaceAll("@", "").replaceAll("_", "").toLowerCase(), v),
    );
    final instructions = <int, String>{};
    for (var n = 0; n < lines.length; n++) {
      final line = lines[n].trim();
      final match = commentAnnotationRegExp.firstMatch(line.toLowerCase());
      if (match != null) {
        final instruction = match.group(1)?.replaceAll("_", "") ?? "";
        instructions[n] = instruction;
        final shouldContinue = await simplifiedAnnotationHandlers[instruction]
            ?.call(n, lines, filePath);
        if (shouldContinue == false) {
          break;
        }
      }
    }
    if (annotationsToDelete.isNotEmpty) {
      final simplifiedAnnotationsToDelete = annotationsToDelete
          .map((e) => e.replaceAll("@", "").replaceAll("_", "").toLowerCase());
      final newLines = List.of(lines);
      for (final instruction in instructions.entries) {
        final n = instruction.key;
        final annotation = instruction.value;
        if (simplifiedAnnotationsToDelete.contains(annotation)) {
          newLines.removeAt(n);
        }
      }
      await writeFile(filePath, newLines.join('\n'));
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final commentAnnotationRegExp = RegExp("^///?\\s*@?(\\w+)\$");
