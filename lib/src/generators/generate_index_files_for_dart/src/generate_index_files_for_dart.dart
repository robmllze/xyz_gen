//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_utils/xyz_utils_non_web.dart' as utils;

import '/src/xyz/_all_xyz.g.dart' as xyz;

import '_utils/_generator_converger.dart';
import '_utils/_insight_mappers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates index files for Dart from directories.
///
/// This function combines [rootDirPaths] and [subDirPaths], applying
/// [pathPatterns] to filter and determine the directories to search for source
/// files.
///
/// The outputs are generated from templates in [templatesRootDirPaths] and the
/// generated files are placed in the appropriate directories.
Future<void> generateIndexFilesForDart({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templatesRootDirPaths,
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

  // Read all templates from templatesRootDirPaths.
  final templateFileExporer = xyz.PathExplorer(
    dirPathGroups: {
      xyz.CombinedPaths(
        templatesRootDirPaths,
      ),
    },
  );
  final templates = await templateFileExporer.readAll();

  // ---------------------------------------------------------------------------

  // Get only the top-most dir paths from all the dir paths explored.
  final topmostDirPathResults = xyz.extractTopmostDirPaths(
    sourceFileExplorerResults.dirPathResults,
    toPath: (e) => e.path,
  );

  // Extract insights from the dir path results.
  final dirInsights = topmostDirPathResults.map((e) => xyz.DirInsight(dir: e));

  // Converge what was gathered to generate the output.
  await generatorConverger.converge(
    dirInsights,
    templates,
    insightMappers,
  );

  // ---------------------------------------------------------------------------

  // Notify end.
  utils.debugLogStop('Done!');
}
