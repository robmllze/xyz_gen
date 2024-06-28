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

/// Generates export files for specified language [lang] from directories using
/// templates located at [templatesRootDirPaths].
///
/// This function combines [rootDirPaths] and [subDirPaths], applying
/// [pathPatterns] to filter and determine the directories to search for source
/// files.
Future<void> generateExportsForDart({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templatesRootDirPaths,
}) async {
  utils.debugLogStart('Starting generator. Please wait...');

  // Explore all source paths.
  final sourceFileExporer = xyz.PathExplorer(
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

  // Generate files for each template.
  final templates = await templateFileExporer.readAll();

  //
  //
  //

  // Get only the topmost dir paths from all the dir paths explored.
  final topmostDirPathResults = xyz.extractTopmostDirPaths(
    sourceFileExplorerResults.dirPathResults,
    toPath: (e) => e.path,
  );

  final insights = topmostDirPathResults.map((e) => _DirInsight(explorerResult: e));

  await generatorConverger.converge(
    insights,
    templates,
    insightMappers,
  );

  utils.debugLogStop('Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final generatorConverger = xyz.GeneratorConverger<_DirInsight, Placeholders>(
  (replacements, templates) async {
    for (final template in templates) {
      // Extract the content from the template.
      final templateContent = xyz.extractCodeFromMarkdown(template.content);

      for (final replacement in replacements) {
        final d = replacement.insight.explorerResult;

        final dirPath = d.path;

        // Fill the template with the replacement data.
        final output = utils.replaceData(
          templateContent,
          replacement.replacements,
        );

        // Determine the output file name.
        final folderName = p.basename(dirPath);
        final outputFileName = [
          '_all_',
          folderName,
          if (templates.length > 1) ...[
            '_',
            template.rootName,
          ],
          '.g.dart',
        ].join();
        final outputFilePath = p.join(dirPath, outputFileName);

        // Write the content to the file.
        await utils.writeFile(
          outputFilePath,
          output,
        );

        utils.debugLogSuccess('Generated "${xyz.previewPath(outputFilePath)}"');
      }
    }
  },
);

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final insightMappers = <xyz.InsightMapper<_DirInsight, Placeholders>>[
  xyz.InsightMapper(
    placeholder: Placeholders.PUBLIC_EXPORTS,
    mapInsights: (insight) async {
      final d = insight.explorerResult;
      final filePaths = d.files.map((e) => p.relative(e.path, from: d.path));
      final exportFilePaths = filePaths.where((e) {
        final baseName = p.basename(e);
        return baseName.endsWith('.dart') && !baseName.endsWith('.g.dart');
      });
      if (exportFilePaths.isNotEmpty) {
        final statements = exportFilePaths.map((e) => "export '$e';");
        return statements.join('\n');
      } else {
        return '// ---';
      }
    },
  ),
  xyz.InsightMapper(
    placeholder: Placeholders.PRIVATE_EXPORTS,
    mapInsights: (e) async {
      return '// ---';
    },
  ),
  xyz.InsightMapper(
    placeholder: Placeholders.GENERATED_EXPORTS,
    mapInsights: (e) async {
      return '// ---';
    },
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum Placeholders {
  PUBLIC_EXPORTS,
  PRIVATE_EXPORTS,
  GENERATED_EXPORTS,
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _DirInsight extends xyz.Insight {
  //
  //
  //

  final xyz.DirPathExplorerResult explorerResult;

  //
  //
  //

  const _DirInsight({
    required this.explorerResult,
  });
}
