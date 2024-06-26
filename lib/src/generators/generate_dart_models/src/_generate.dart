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

import '_analyze_dart_file.dart';
import '_generate_files_from_analysis_results.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateDartModels({
  String? fallbackDartSdkPath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templateFilePaths,
  String? output,
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

      final classInsights = await analyzeDartFile(
        analysisContextCollection,
        filePath,
      );
      await generateFilesFromAnalysisResults(
        insights: classInsights,
        templates: integratorResult.templates,
      );
    },
  );
  utils.debugLogStop('Done!');
}
