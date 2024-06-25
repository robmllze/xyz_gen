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
import 'package:xyz_utils/xyz_utils_non_web.dart';

import '/src/core_utils/core_utils_on_lang_extension.dart';
import '/src/core_utils/find_files_etc.dart';
import '/src/core_utils/read_code_snippets_from_markdown_file.dart';
import '/src/language_support_utils/lang.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates export files for specified language [lang] and directories.
///
/// Directories are a combination of [rootDirPaths] and [subDirPaths], filtered
/// by [pathPatterns]. Export statements are generated for each export file
/// based on the [exportStatement] function. Optionally, the [exportIf]
/// function can be used to determine if a particular file should be exported
/// and a [templateFilePath] can be provided to customize the output.
Future<void> generateExports({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Lang lang,
  required String Function(String relativeFilePath) exportStatement,
  bool Function(String exportFilePath)? exportIf,
  String? templateFilePath,
}) async {
  debugLogStart('Starting generator. Please wait...');
  // Read the template.
  final template = await _readTemplate(templateFilePath, lang);
  // Loop through all directory combinations.
  final combinedDirPaths = combinePathSets([rootDirPaths, subDirPaths]);
  for (final dirPath in combinedDirPaths) {
    // Determine the output file path.
    final folderName = p.basename(dirPath).toLowerCase();
    final outputFileName = '_all_$folderName${lang.genExt}';
    final outputFilePath = p.join(dirPath, outputFileName);

    final outputBuffer = <String, String>{};

    // Find all Dart files in dirPath.
    await findSourceFiles(
      dirPath,
      lang: Lang.DART,
      pathPatterns: pathPatterns,
      onFileFound: (_, __, exportFilePath) async {
        // Prevent the export file from exporting itself.
        if (exportFilePath == outputFilePath) return false;
        // Get the export path relative to the dirPath as a unix path.
        final relativeFilePath = toUnixSystemPathFormat(p.relative(exportFilePath, from: dirPath));
        // Write the export statement to the output file if it is determined that
        // it should be exported by the shouldExport function.
        if (exportIf?.call(exportFilePath) ?? true) {
          final content = exportStatement(relativeFilePath);
          outputBuffer[outputFilePath] = (outputBuffer[outputFilePath] ?? '') + content;
          return true;
        } else {
          debugLogAlert('Skipped $exportFilePath');
        }
        return false;
      },
    );

    // Write all output files.
    for (final output in outputBuffer.entries) {
      final filePath = output.key;
      final exports = output.value;
      final content = replaceData(
        template,
        {
          '___EXPORTS___': exports,
        },
      );
      await writeFile(
        filePath,
        content,
      );
      debugLog(
        'Added "${exports.replaceAll('\n', '')}" to ...${p.joinAll(p.split(outputFilePath).takeLast(3))}',
      );
    }
  }
  debugLogStop('Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<String> _readTemplate(String? templateFilePath, Lang lang) async {
  if (templateFilePath != null) {
    final snippets = await readCodeSnippetsFromMarkdownFile(
      templateFilePath,
      langCode: lang.langCode,
    );
    final template = '${snippets.join('\n')}\n\n';
    return template;
  } else {
    return '';
  }
}
