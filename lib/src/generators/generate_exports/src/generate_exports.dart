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
  required String templateFilePath,
  String Function(TPlaceholder placeholder)? placeholderBuilder,
}) async {
  utils.debugLogStart('Starting generator. Please wait...');

  final templateIntegrator = xyz.TemplateIntegrator<TPlaceholder, Null>(
    rootDirPaths: rootDirPaths,
    subDirPaths: subDirPaths,
  );

  var outputBuffer = <String, Map<TPlaceholder, List<String>>>{};
  late final String template;

  await templateIntegrator.engage(
    templateFilePaths: {templateFilePath},
    onTemplatesRead: (templates) async => template = templates.values.first,
    onSourceFile: (integratorResult) async {
      final targetDirPath = integratorResult.targetDirPath;
      final filePath = integratorResult.source.filePath;
      final relativeFilePath = Uri.file(
        p.relative(filePath, from: targetDirPath),
        windows: false,
      ).path;

      // Determine the status and statement
      final status = statusBuilder?.call(filePath);
      final statement = statementBuilder?[status]?.call(relativeFilePath);

      final rootFolderName = p.basename(targetDirPath);
      final outputFileName = '_all_$rootFolderName${lang.genExt}';
      final outputFilePath = p.join(targetDirPath, outputFileName);

      // Add the statement to the output buffer under the status.
      if (status != null && statement != null) {
        outputBuffer[outputFilePath] ??= {};
        (outputBuffer[outputFilePath]![status] ??= []).add(statement);
      }
    },
  );

  // Write all output files.
  for (final output in outputBuffer.entries) {
    final filePath = output.key;
    final exportStatements = output.value;
    // Replace template placeholders with actual data.
    var content = utils.replaceData(
      template,
      exportStatements.map((k, v) => MapEntry(k.placeholder, v.join('\n'))),
    );
    // Clear the remaining unused placeholders.
    final clearRemainingPlaceholders =
        statementBuilder?.map((k, v) => MapEntry(k.placeholder, placeholderBuilder?.call(k) ?? ''));
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

  utils.debugLogStop('Done!');
}
