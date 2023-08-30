// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';

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
    await findDartFiles(
      path,
      pathPatterns: pathPatterns,
      onFileFound: (_, __, final filePath) async {
        final folderName = getBaseName(path);
        final allFilePath = join(path, "all_$folderName.dart");
        if (path != cachedDirName) {
          cachedDirName = path;
          printGreen("Clearing `$allFilePath`...");
          final data = replaceAllData(template, {"___EXPORTS___": ""});
          await writeFile(
            allFilePath,
            data,
          );
        }
        if (filePath != allFilePath) {
          final relativeFilePath = filePath.replaceFirst(path, "");
          final fileName = getBaseName(filePath);
          final private = fileName.startsWith("_");
          final data = "${private ? "//" : ""}export '$relativeFilePath';";

          await writeFile(
            allFilePath,
            "$data\n",
            append: true,
          );
          printGreen("Writing `$data` to `$allFilePath`...");
          return true;
        } else {
          printGreen("Skipping `$filePath`...");
          return false;
        }
      },
    );
  }
}
