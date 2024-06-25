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

/// TODO:....
Future<void> generateDartExports({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Lang lang,
  required String Function(String relativeFilePath) exportStatement,
  bool Function(String exportFilePath)? exportIf,
  required String templateFilePath,
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  var workingDirPath = '';
  // Read the template.
  final template = (await readCodeSnippetsFromMarkdownFile(
    templateFilePath,
    langCode: lang.langCode,
  ))
      .join('\n');

  // Loop through all directory combinations.
  final combinedDirPaths = combinePathSets([rootDirPaths, subDirPaths]);
  for (final dirPath in combinedDirPaths) {
    // Determine the output file path.
    final folderName = p.basename(dirPath).toLowerCase();
    final outputFileName = '_all_$folderName${lang.genExt}';
    final outputFilePath = p.join(dirPath, outputFileName);
    // Find all Dart files in dirPath.
    await findSourceFiles(
      dirPath,
      lang: Lang.DART,
      pathPatterns: pathPatterns,
      onFileFound: (_, __, exportFilePath) async {
        // Clear the output file with new template data if it is not the
        // current file being worked on.
        if (dirPath != workingDirPath) {
          workingDirPath = dirPath;
          await writeFile(outputFilePath, '$template\n\n');
        }
        // Prevent the export file from exporting itself.
        if (exportFilePath == outputFilePath) return false;
        // Get the export path relative to the dirPath as a unix path.
        final relativeFilePath = toUnixSystemPathFormat(p.relative(exportFilePath, from: dirPath));
        // Write the export statement to the output file if it is determined that
        // it should be exported by the shouldExport function.
        if (exportIf?.call(exportFilePath) ?? true) {
          final content = exportStatement(relativeFilePath);
          await writeFile(
            outputFilePath,
            content,
            append: true,
          );
          debugLog(
            'Added "${content.replaceAll('\n', '')}" to ...${p.joinAll(p.split(outputFilePath).reversed.take(3).toList().reversed)}',
          );
          return true;
        } else {
          debugLogAlert('Skipped $exportFilePath');
        }

        return false;
      },
    );
  }
  Here().debugLogStop('Done!');
}
