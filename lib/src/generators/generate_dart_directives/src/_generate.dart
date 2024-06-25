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

import '/src/sdk/_all_sdk.g.dart' as sdk;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates missing directive files for Dart source files based on specified
/// comment annotations.
///
/// Processes all file paths resulting from the combination of [rootDirPaths]
/// and [subDirPaths], filtered by [pathPatterns].
Future<void> generateDartDirectives({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  utils.debugLogStart('Starting generator. Please wait...');
  // Loop through all directory combinations.
  final combinedDirPaths = utils.combinePathSets([rootDirPaths, subDirPaths]);
  for (final dirPath in combinedDirPaths) {
    // Find all Dart files from dirPath.
    final srcFiles = await sdk.findSourceFiles(
      dirPath,
      lang: sdk.Lang.DART,
      pathPatterns: pathPatterns,
    );
    final annotations = {
      '@GenerateDirectives',
      'gd',
    };
    for (final scrFile in srcFiles) {
      // Call _onAnnot for each of the specified annotations found in srcFile.
      await sdk.processCommentAnnots(
        filePath: scrFile.filePath,
        onAnnotCallbacks: annotations.map((e) => MapEntry(e, _onAnnot)).toMap(),
        annotsToDelete: annotations,
      );
    }
    utils.debugLogStop('Done!');
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Handles the case where the code is annotated with @GenerateDirectives.
Future<bool> _onAnnot(
  int startIndex,
  List<String> lines,
  String filePath,
) async {
  try {
    // Find the directory path of the file.
    final dirPath = p.dirname(filePath);

    // Loop through the lines starting from the line after the annotation.
    for (var i = startIndex + 1; i < lines.length; i++) {
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
          utils.debugLogMessage(
            'Created "part" file ${p.joinAll(p.split(normalDirectiveFilePath).takeLast(3))} for ${p.joinAll(p.split(filePath).takeLast(3))}',
          );
        // Create import file.
        case 'import':
          await utils.writeFile(
            normalDirectiveFilePath,
            '// Imported by $counterpartFilePath',
          );
          utils.debugLogMessage(
            'Created "import" file ${p.joinAll(p.split(normalDirectiveFilePath).takeLast(3))} for ${p.joinAll(p.split(filePath).takeLast(3))}',
          );
        // Create export file.
        case 'export':
          await utils.writeFile(
            normalDirectiveFilePath,
            '// Exported by $counterpartFilePath',
          );
          utils.debugLogMessage(
            'Created "export" file ${p.joinAll(p.split(normalDirectiveFilePath).takeLast(3))} for ${p.joinAll(p.split(filePath).takeLast(3))}',
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
