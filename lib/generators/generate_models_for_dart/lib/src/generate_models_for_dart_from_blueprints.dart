//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_config/xyz_config.dart';
import 'package:xyz_utils/xyz_utils.dart' as utils;
import 'package:xyz_utils/xyz_utils_non_web.dart';

import '/src/xyz/_index.g.dart' as xyz;

import '_utils/_extract_class_insights_from_dart_file.dart';
import '_utils/_generator_converger.dart';
import '_utils/_insight_mappers_a.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModelsForDartFromBlueprints({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templatesRootDirPaths,
  String? fallbackDartSdkPath,
}) async {
  // Notify start.
  utils.debugLogStart('Starting generator. Please wait...');

  // Explore all source paths.
  final sourceFileExporer = xyz.PathExplorer<ConfigFileType>(
    categorizedPathPatterns: const [
      xyz.CategorizedPattern(
        category: ConfigFileType.JSON,
        pattern: r'(^.*\.)?blueprints\.json$',
      ),
      xyz.CategorizedPattern(
        category: ConfigFileType.JSONC,
        pattern: r'(^.*\.)?blueprints\.jsonc$',
      ),
      xyz.CategorizedPattern(
        category: ConfigFileType.YAML,
        pattern: r'(^.*\.)?blueprints\.yaml$',
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

  for (final filePathResult in sourceFileExplorerResults.filePathResults) {
    if (ConfigFileType.values.contains(filePathResult.category)) {
      // Read the blueprint file.
      final fileConfig = FileConfig(
        ref: ConfigFileRef(
          type: filePathResult.category,
          read: () async {
            final contents = await readFile(filePathResult.path);
            return contents ?? '';
          },
        ),
        settings: const ReplacePatternsSettings(caseSensitive: false),
      );
      final success = await fileConfig.readAssociatedFile();

      //fileConfig.fields['models']?[]

      //printRed(fileConfig.fields);
    }
  }

  // // For each file...
  // for (final filePathResult in sourceFileExplorerResults.filePathResults) {
  //   final filePath = filePathResult.path;

  //   // Extract insights from the file.
  //   final classInsights = await extractClassInsightsFromDartFile(
  //     analysisContextCollection,
  //     filePath,
  //   );

  //   // Converge what was gathered to generate the output.
  //   await generatorConverger.converge(
  //     classInsights,
  //     templates,
  //     insightMappers,
  //   );
  //}

  // ---------------------------------------------------------------------------

  // Notify end.
  utils.debugLogStop('Done!');
}
