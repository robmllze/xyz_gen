//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils_non_web.dart' as utils;

import '/src/xyz/_all_xyz.g.dart' as xyz;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates missing directives for Dart files
///
/// This function combines [rootDirPaths] and [subDirPaths], applying
/// [pathPatterns] to filter and determine the directories to search for source
/// files.
///
/// The outputs are generated from special comment annotations.
Future<void> generateDirectivesForDart({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  // Notify start.
  utils.debugLogStart('Starting generator. Please wait...');

  // Explore all source paths.
  final sourceFileExporer = xyz.PathExplorer(
    categorizedPathPatterns: const [
      xyz.CategorizedPattern(
        pattern: r'.*\.dart$',
      ),
    ],
    dirPathGroups: {
      xyz.CombinedPaths(
        rootDirPaths,
        subPaths: subDirPaths,
        pathPatterns: pathPatterns,
      ),
    },
  );
  final sourceFileExplorerResults = await sourceFileExporer.explore();

  // ---------------------------------------------------------------------------

  const ANNOTS = {
    '@@@GenerateDirectives',
    '@@@gd',
  };

  // For each file...
  for (final filePathResult in sourceFileExplorerResults.filePathResults) {
    final filePath = filePathResult.path;

    // Call _onAnnot for each of the specified annotations found in srcFile.
    await xyz.processCommentAnnots(
      filePath: filePath,
      onAnnotCallbacks: ANNOTS.map((e) => MapEntry(e, _onAnnot)).toMap(),
      annotsToDelete: ANNOTS,
    );
  }

  // ---------------------------------------------------------------------------

  // Notify end.
  utils.debugLogStop('Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Handles the case where the code is annotated.
Future<bool> _onAnnot(
  int annotIndex,
  List<String> lines,
  String filePath,
) async {
  try {
    // Find the directory path of the file.
    final dirPath = p.dirname(filePath);

    // Loop through the lines starting from the line after the annotation.
    for (var i = annotIndex + 1; i < lines.length; i++) {
      // Try to locate the directive string, such as "import '../hello_world.dart'",
      // in the line, or continue if none is found.
      final line = lines[i].trim();
      final directiveMatch = RegExp('^(\\w+)\\s+[\'"](.+)[\'"];\$').firstMatch(line);
      if (directiveMatch == null) continue;

      // Extract the relative directive file path from the match or quit if
      // it doesn't exist.
      final relativeDirectiveFilePath = directiveMatch.group(2);
      if (relativeDirectiveFilePath == null || relativeDirectiveFilePath.isEmpty) {
        return false;
      }

      // Find the directive file path relative to dirPath.
      final normalDirectiveFilePath = p.normalize(p.join(dirPath, relativeDirectiveFilePath));

      // Continue if the file already exist.
      final exists = await utils.fileExists(normalDirectiveFilePath);
      if (exists) {
        continue;
      }

      // Extract the directive type that's either "part", "import" or "export".
      final directiveType = directiveMatch.group(1);

      // Find filePath's counterpart file path, e.g. the relative path that
      // points back to filePath.
      final counterpartFilePath = p.relative(filePath, from: p.dirname(normalDirectiveFilePath));

      switch (directiveType) {
        // Create part file.
        case 'part':
          await utils.writeFile(
            normalDirectiveFilePath,
            "part of '$counterpartFilePath';",
          );

          // Log a success.
          utils
              .debugLogSuccess('Generated "part" file ${xyz.previewPath(normalDirectiveFilePath)}');
        // Create import file.
        case 'import':
          await utils.writeFile(
            normalDirectiveFilePath,
            '// Imported by $counterpartFilePath',
          );
          // Log a success.
          utils.debugLogSuccess(
            'Generated "import" file ${xyz.previewPath(normalDirectiveFilePath)}',
          );
        // Create export file.
        case 'export':
          // Log a success.
          await utils.writeFile(
            normalDirectiveFilePath,
            '// Exported by $counterpartFilePath',
          );
          utils.debugLogSuccess(
            'Generated "export" file ${xyz.previewPath(normalDirectiveFilePath)}',
          );
        default:
          throw UnimplementedError('Unknown directive type: $directiveType');
      }
    }
  } catch (e) {
    utils.debugLogError(e);
  }
  return true;
}
