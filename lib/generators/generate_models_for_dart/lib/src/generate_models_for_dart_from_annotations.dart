//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_utils/xyz_utils.dart' as utils;

import '/src/xyz/_index.g.dart' as xyz;

import '_utils/_extract_class_insights_from_dart_file.dart';
import '_utils/_generator_converger.dart';
import '_utils/_insight_mappers_a.dart';
import '_utils/_insight_mappers_b.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates Dart model files from insights derived from classes annotated
/// with `@GenerateModel` in Dart source files.
///
/// This function combines [rootDirPaths] and [subDirPaths], applying
/// [pathPatterns] to filter and determine the directories to search for source
/// files.
///
/// The outputs are generated from templates in [templatesRootDirPaths] and the
/// generated files are placed in the same directories as the source
/// files.
///
/// If the `DART_SDK` environment variable is not set, [fallbackDartSdkPath] is
/// used. This function leverages Dart's analyzer to interpret the annotations.
Future<void> generateModelsForDartFromAnnotations({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templatesRootDirPaths,
  String? fallbackDartSdkPath,
}) async {
  // Notify start.
  utils.debugLogStart('Starting generator. Please wait...');

  // Explore all source paths.
  final sourceFileExporer = xyz.PathExplorer(
    categorizedPathPatterns: const [
      xyz.CategorizedPattern(
        category: _Categories.DART,
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

  // Create context for the Dart analyzer.
  final analysisContextCollection = xyz.createDartAnalysisContextCollection(
    sourceFileExporer.dirPathGroups.first.paths,
    fallbackDartSdkPath,
  );

  // For each file...
  for (final filePathResult
      in sourceFileExplorerResults.filePathResults.where((e) => e.category == _Categories.DART)) {
    final filePath = filePathResult.path;

    // Extract insights from the file.
    final classInsights = await extractClassInsightsFromDartFile(
      analysisContextCollection,
      filePath,
    );

    if (classInsights.isNotEmpty) {
      // Converge what was gathered to generate the output.
      await generatorConverger.converge(
        classInsights,
        templates,
        [
          ...insightMappersA,
          ...insightMappersB,
        ],
      );
    }
  }

  // ---------------------------------------------------------------------------

  // Notify end.
  utils.debugLogStop('Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum _Categories {
  DART,
}
