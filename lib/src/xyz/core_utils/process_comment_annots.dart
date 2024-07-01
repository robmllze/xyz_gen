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

/// Processes comment annotations in the file at [filePath], invoking the
/// appropriate callbacks from [onAnnotCallbacks] for each annotation found.
///
/// Optionally removes annotations specified in [annotsToDelete].
///
/// Comment annotations are identified by lines starting with `//` or `///`
/// followed by the annotation key or the first capture group in
/// [commentAnnotPattern].
///
/// Strings matching [ignorePattern] within annotations are ignored.
Future<void> processCommentAnnots({
  required String filePath,
  required Map<String, _TLineCallback> onAnnotCallbacks,
  required Set<String> annotsToDelete,
  String ignorePattern = r'[@_\s]',
  String commentAnnotPattern = r'^///?\s*@?([\w ]+)$',
}) async {
  final ignoreExp = RegExp(ignorePattern);
  final commentAnnotExp = RegExp(commentAnnotPattern);

  // Read all lines from the specified file at filePath.
  final lines = await readFileAsLines(filePath);
  if (lines == null || lines.isEmpty) return;

  // Strip strings per ignorePattern from annotationHandlers.
  String $strip(String e) => e.replaceAll(ignoreExp, '').toLowerCase();
  final onAnnotCallbacks1 = onAnnotCallbacks.map((k, v) => MapEntry($strip(k), v));

  final annots = <int, String>{};

  // Iterate through all lines in the file.
  for (var lineNumber = 0; lineNumber < lines.length; lineNumber++) {
    final line = lines[lineNumber].trim();

    // Find the comment annotation (the first capture group) from
    //commentAnnotPattern in the current line if it exists, or continue.
    final annot0 = commentAnnotExp.firstMatch(line.toLowerCase())?.group(1);
    if (annot0 == null) continue;

    // Strip strings per ignorePattern.
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

  // Remove all annots from lines specified in annotsToDelete.
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
