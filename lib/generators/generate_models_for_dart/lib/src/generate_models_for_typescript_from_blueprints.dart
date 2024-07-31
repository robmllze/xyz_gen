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
import 'package:xyz_config/xyz_config.dart';
import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart';
import 'package:xyz_utils/xyz_utils.dart' as utils;

import '/src/xyz/_index.g.dart' as xyz;

import '_utils/_typescript_generator_converger.dart';
import '_utils/_typescript_insight_mappers_a.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModelsForTypeScriptFromBlueprints({
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
      if (success) {
        final g = Generate.fromJson(fileConfig.data.mapKeys((e) => e.toString()));
        final configFileDirPath = p.dirname(filePathResult.path);
        final t0 =
            g.templateFilePaths?.map((e) => p.normalize(p.join(configFileDirPath, e))).toSet() ??
                {};
        final t1 = templatesRootDirPaths;

        // Read all templates from templatesRootDirPaths.
        final templateFileExporer = xyz.PathExplorer(
          dirPathGroups: {if (t0.isNotEmpty) xyz.CombinedPaths(t0) else xyz.CombinedPaths(t1)},
        );
        final templates = await templateFileExporer.readAll();

        final annotations = g.annotations?.map((e) => GenerateModel.from(e));

        if (annotations != null) {
          // Extract insights from the file.
          final classInsights = annotations.map(
            (e) {
              final annotation = e.copyWith(
                GenerateModel(
                  fields: e.fields?.map((e) {
                    return Field.fromJson(e).toRecord;
                  }).toSet(),
                ),
              );
              final dirPath = p.join(configFileDirPath, g.outputDirPath!);
              return xyz.ClassInsight(
                annotation: annotation,
                className: e.className!,
                dirPath: dirPath,
                fileName: '${e.className!.toSnakeCase()}.ts',
              );
            },
          );

          if (classInsights.isNotEmpty) {
            // Converge what was gathered to generate the output.
            await generatorConverger.converge(
              classInsights,
              templates,
              [
                ...typeScriptInsightMappers,
              ],
            );
          }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------

  // Notify end.
  utils.debugLogStop('Done!');
}
