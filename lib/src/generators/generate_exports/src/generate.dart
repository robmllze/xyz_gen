//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateExports({
  required String templateFilePath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  var cachedDirPath = '';
  // Get the template to use.
  final template =
      (await readSnippetsFromMarkdownFile(templateFilePath)).join('\n');
  // Loop through all possible directories.
  final combinedDirPaths = combinePathSets([rootDirPaths, subDirPaths]);
  for (final dirPath in combinedDirPaths) {
    // Determine the output file path from dirPath.
    final folderName = p.basename(dirPath).toLowerCase();
    final outputFileName = '_all_$folderName.g.dart';
    final outputFilePath = p.join(dirPath, outputFileName);
    // Find all Dart files in dirPath.
    await findFiles(
      dirPath,
      extensions: {'.dart'},
      pathPatterns: pathPatterns,
      onFileFound: (_, __, filePath) async {
        // Create the file if it doesn't exist.
        if (dirPath != cachedDirPath) {
          cachedDirPath = dirPath;
          await writeFile(outputFilePath, '$template\n\n');
        }
        // Let's not add the output file to itself.
        if (filePath != outputFilePath) {
          // Get the relative file path.
          var relativeFilePath = filePath.replaceFirst(dirPath, '');
          // Remove the initial '/' from the relative file path if present.
          relativeFilePath = relativeFilePath.startsWith(p.separator)
              ? relativeFilePath.substring(1)
              : relativeFilePath;
          relativeFilePath = toUnixSystemPathFormat(relativeFilePath);
          // Get the file name from the file path.
          final fileName = p.basename(filePath);
          // Check if the file is private / if it starts with '_'.
          final private = fileName.startsWith('_');
          // Write the export statement to the output file if it's not private.
          if (!private) {
            await writeFile(
              outputFilePath,
              "export '$relativeFilePath';\n",
              append: true,
            );
            return true;
          }
        }
        return false;
      },
    );
  }
  Here().debugLogStop('Done!');
}
