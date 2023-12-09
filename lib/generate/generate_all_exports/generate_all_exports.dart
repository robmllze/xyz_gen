//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '../../_internal_dependencies.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateAllExports({
  required String templateFilePath,
  required Set<String> rootPaths,
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  final combinedPaths = combinePaths([rootPaths, subPaths]);
  var cachedDirName = "";
  final template = await readDartTemplate(templateFilePath);
  for (final path in combinedPaths) {
    final folderName = getBaseName(path);
    final outputFileName = "all_$folderName.g.dart";
    final outputFilePath = join(path, outputFileName);

    await findDartFiles(
      path,
      pathPatterns: pathPatterns,
      onFileFound: (_, __, final filePath) async {
        if (path != cachedDirName) {
          cachedDirName = path;
          printGreen("Clearing `$outputFileName`...");
          final data = replaceAllData(template, {"___BODY___": ""});
          await writeFile(outputFilePath, data);
        }
        if (filePath != outputFilePath) {
          var relativeFilePath = filePath.replaceFirst(path, "");
          // Remove the initial "/" if present.
          relativeFilePath = relativeFilePath.startsWith(separator)
              ? relativeFilePath.substring(1)
              : relativeFilePath;
          final fileName = getBaseName(filePath);
          final private = fileName.startsWith("_");
          if (!private) {
            await writeFile(
              outputFilePath,
              "export '$relativeFilePath';\n",
              append: true,
            );
            printGreen("Adding `$relativeFilePath` to `$outputFileName`...");
          }
          return true;
        } else {
          printGreen("Skipping `$outputFileName`...");
          return false;
        }
      },
    );
  }
}
