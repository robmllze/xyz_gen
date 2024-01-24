//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/utils/all_utils.g.dart';
import '/xyz_utils/all_xyz_utils.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateExports({
  required String templateFilePath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  var cachedDirPath = "";
  // Get the template to use.
  final template =
      (await readDartSnippetsFromMarkdownFile(templateFilePath)).join("\n");
  // Loop through all possible directories.
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    // Determine the output file name from dirPath.
    final folderName = getBaseName(dirPath);
    final outputFileName = "all_$folderName.g.dart";
    final outputFilePath = p.join(dirPath, outputFileName);
    // Find all Dart files in dirPath.
    await findDartFiles(
      dirPath,
      pathPatterns: pathPatterns,
      onFileFound: (_, __, filePath) async {
        // Create the file if it doesn't exist.
        if (dirPath != cachedDirPath) {
          cachedDirPath = dirPath;
          printGreen("Creating `$outputFileName`...");
          await writeFile(outputFilePath, "$template\n\n");
        }
        // Let's not add the output file to itself.
        if (filePath != outputFilePath) {
          // Get the relative file path.
          var relativeFilePath = filePath.replaceFirst(dirPath, "");
          // Remove the initial "/" from the relative file path if present.
          relativeFilePath = relativeFilePath.startsWith(p.separator)
              ? relativeFilePath.substring(1)
              : relativeFilePath;
          // Get the file name from the file path.
          final fileName = getBaseName(filePath);
          // Check if the file is private / if it starts with "_".
          final private = fileName.startsWith("_");
          // Write the export statement to the output file if it's not private.
          if (!private) {
            printGreen("Adding `$relativeFilePath` to `$outputFileName`...");
            await writeFile(
              outputFilePath,
              "export '$relativeFilePath';\n",
              append: true,
            );
            return true;
          }
        }
        printGreen("Skipping `$outputFileName`...");
        return false;
      },
    );
  }
}
