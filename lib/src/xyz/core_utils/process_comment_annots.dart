//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_utils/xyz_utils_non_web.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Processes comment annotations in the file at [filePath] and invokes the
/// corresponding callbacks from [onAnnotCallbacks] for each annotation found.
///
/// Optionally, it deletes annotations specified in [annotsToDelete].
///
/// Comment annotations start with `//` or `///` followed by the annotation key.
Future<void> processCommentAnnots({
  required String filePath,
  required Map<String, _TLineCallback> onAnnotCallbacks,
  required Set<String> annotsToDelete,
}) async {
  final ignorablesRegExp = RegExp(r'[@_\s]');
  final commentAnnotRegExp = RegExp('^///?\\s*@?([\\w ]+)\$');
  String $strip(String e) => e.replaceAll(ignorablesRegExp, '').toLowerCase();

  // Read all lines in filePath.
  final lines = await readFileAsLines(filePath);
  if (lines == null || lines.isEmpty) return;

  // Strip ignorables from annotationHandlers.
  final onAnnotCallbacks1 = onAnnotCallbacks.map((k, v) => MapEntry($strip(k), v));

  final annots = <int, String>{};

  // Loop through lines.
  for (var lineNumber = 0; lineNumber < lines.length; lineNumber++) {
    final line = lines[lineNumber].trim();

    // Find the comment annotation at the current line if it exists, or continue.
    final annot0 = commentAnnotRegExp.firstMatch(line.toLowerCase())?.group(1);
    if (annot0 == null) continue;

    // Strip ignorables from annot0.
    final annot1 = $strip(annot0);

    // Save all annots.
    annots[lineNumber] = annot1;

    // Process the annot.
    final proceed = await onAnnotCallbacks1[annot1]!(lineNumber, lines, filePath);

    // Break the loop if the callback returns false.
    if (!proceed) {
      break;
    }
  }

  // Remove all comment annotations specified in annotsToDelete.
  if (annotsToDelete.isNotEmpty) {
    final annotsToDelete1 = annotsToDelete.map($strip);
    final lines1 = List.of(lines);
    for (final annot in annots.entries) {
      final index = annot.key;
      final annotation = annot.value;
      if (annotsToDelete1.contains(annotation)) {
        lines1.removeAt(index);
      }
    }
    await writeFile(filePath, lines1.join('\n'));
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _TLineCallback = Future<bool> Function(
  int lineNumber,
  List<String> lines,
  String filePath,
);
