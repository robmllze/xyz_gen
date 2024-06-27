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
/// The models are created using templates specified in [templateFilePaths].
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
  required Set<String> templateFilePaths,
}) async {
  utils.debugLogStart('Starting generator. Please wait...');
  final templateIntegrator = xyz.TemplateIntegrator(
    // Evaluate files in these paths.
    rootDirPaths: rootDirPaths,
    subDirPaths: subDirPaths,
    // Evaluate paths that adhere to these patterns.
    pathPatterns: pathPatterns,
  );

  // Create context for the Dart analyzer.
  final analysisContextCollection = xyz.createDartAnalysisContextCollection(
    templateIntegrator.combinedDirPaths,
    fallbackDartSdkPath,
  );

  // Read all templates from templateFilePaths and engage them with the files
  // under consideration.
  await templateIntegrator.engage(
    templateFilePaths: templateFilePaths,
    // For every source file found in the paths being evaluated...
    onSourceFile: (integratorResult) async {
      final filePath = integratorResult.source.filePath;
      final isSrcFile = xyz.Lang.DART.isValidSrcFilePath(filePath);

      // Skip if the file being evaluated isn't a Dart souce file, i.e. ends
      // with '.dart' but not with '.g.dart'.
      if (!isSrcFile) return;

      final classInsights = await extractClassInsightsFromDartFile(
        analysisContextCollection,
        filePath,
      );

      // Converge the insights, templates, and replacements.
      await generatorConverger.converge(
        classInsights,
        integratorResult.templates,
        insightMappers,
      );
    },
  );
  utils.debugLogStop('Done!');
}
