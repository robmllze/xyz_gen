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

import '/src/xyz/_all_xyz.g.dart' as xyz;

import '_utils/_extract_class_insights_from_dart_file.dart';
import '_utils/_generator_converger.dart';
import '_utils/_insight_mappers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates Dart model files from insights derived from classes annotated
/// with `@GenerateModel` in Dart source files.
///
/// The models are created using templates specified in [templatesRootDirPaths].
///
/// This function combines [rootDirPaths] and [subDirPaths], applying
/// [pathPatterns] to filter and determine the directories to search for source
/// files. The generated files are placed in the same directories as the source
/// files.
///
/// If the `DART_SDK` environment variable is not set, [fallbackDartSdkPath] is
/// used. This function leverages Dart's analyzer to interpret the annotations.
Future<void> generateModelsForDartFromAnnotations({
  String? fallbackDartSdkPath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templatesRootDirPaths,
}) async {
  utils.debugLogStart('Starting generator. Please wait...');

  final templateFileExporer = xyz.PathExplorer(
    dirPathGroups: {
      xyz.CombinedPaths(
        templatesRootDirPaths,
      ),
    },
  );

  final templates = await templateFileExporer.readAll();

  final sourceFileExporer = xyz.PathExplorer(
    categorizedPathPatterns: const [
      xyz.CategorizedPattern(
        category: '',
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

  // Create context for the Dart analyzer.
  final analysisContextCollection = xyz.createDartAnalysisContextCollection(
    sourceFileExporer.dirPathGroups.first.paths,
    fallbackDartSdkPath,
  );

  for (final result in sourceFileExplorerResults.filePathResults) {
    final filePath = result.path;

    final classInsights = await extractClassInsightsFromDartFile(
      analysisContextCollection,
      filePath,
    );

    // Converge the insights, templates, and replacements.
    await generatorConverger.converge(
      classInsights,
      templates,
      insightMappers,
    );
  }

  utils.debugLogStop('Done!');
}
