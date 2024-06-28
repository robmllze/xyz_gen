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
import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart' as utils;

import '/src/xyz/_all_xyz.g.dart' as xyz;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates export files for specified language [lang] from directories using
/// templates located at [templateFilePath].
///
/// The function combines [rootDirPaths] and [subDirPaths], filtered by
/// [pathPatterns], to process directories. It generates export files by
/// creating statements with [statementBuilder] based on the status determined
/// by [statusBuilder]. These statuses and corresponding statements are then
/// integrated into the template read from [templateFilePath] to create the
/// final export files.
///
/// The [placeholderBuilder] can be used to replace all placeholders in the
/// template with actual data.
Future<void> generateExports<TPlaceholder extends Enum>({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required xyz.Lang lang,
  Map<TPlaceholder, String Function(String relativeFilePath)>? statementBuilder,
  TPlaceholder? Function(String exportFilePath)? statusBuilder,
  required Set<String> templatesRootDirPaths,
  String Function(TPlaceholder placeholder)? placeholderBuilder,
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
    dirPathGroups: {
      xyz.CombinedPaths(
        rootDirPaths,
        subPaths: subDirPaths,
        pathPatterns: pathPatterns,
      ),
    },
  );

  final sourceFileExplorerResults = await sourceFileExporer.explore();

  for (final template in templates.entries) {
    final templateName = p.basename(template.key).replaceFirst(RegExp(r'\..*'), '');
    final templateContent = xyz.extractCodeFromMarkdown(template.value);

    final topmpstDirPathResults = xyz.extractTopmostDirPathResults(
      sourceFileExplorerResults.dirPathResults,
      toPath: (e) => e.path,
    );

    for (final dirPathResult in topmpstDirPathResults) {
      final dirPath = dirPathResult.path;
      final folderName = p.basename(dirPath);

      final outputFileName = [
        '_all_',
        folderName,
        if (templates.length > 1) ...[
          '_',
          templateName,
        ],
        lang.genExt,
      ].join();

      final outputFilePath = p.join(dirPath, outputFileName);
      final outputBuffer = <String, Map<TPlaceholder, List<String>>>{};

      final filePathResultsForDir =
          sourceFileExplorerResults.filePathResults.where((e) => e.path.startsWith(dirPath));

      for (final filePathResult in filePathResultsForDir) {
        final filePath = filePathResult.path;
        final relativeFilePath = p.relative(filePath, from: dirPath);

        // Determine the status and statement.
        final status = statusBuilder?.call(filePath);
        final statement = statementBuilder?[status]?.call(relativeFilePath);

        // Add the statement to the output buffer under the status.
        if (status != null && statement != null) {
          outputBuffer[outputFilePath] ??= {};
          (outputBuffer[outputFilePath]![status] ??= []).add(statement);
        }
      }

      // Write all output files.
      for (final output in outputBuffer.entries) {
        final filePath = output.key;
        final exportStatements = output.value;
        // Replace template placeholders with actual data.
        var content = utils.replaceData(
          templateContent,
          exportStatements.map((k, v) => MapEntry(k.placeholder, v.join('\n'))),
        );
        // Clear the remaining unused placeholders.
        final clearRemainingPlaceholders = statementBuilder
            ?.map((k, v) => MapEntry(k.placeholder, placeholderBuilder?.call(k) ?? ''));
        if (clearRemainingPlaceholders != null) {
          content = utils.replaceData(content, clearRemainingPlaceholders);
        }
        await utils.writeFile(
          filePath,
          content,
        );

        // Log a success.
        utils.debugLogSuccess('Generated "${xyz.previewPath(filePath)}"');
      }
    }
  }

  utils.debugLogStop('Done!');
}
