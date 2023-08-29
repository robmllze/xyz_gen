// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_utils/xyz_utils_non_web.dart';
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateAllExports({
  String rootDirPath = "./",
  Set<String> subDirPaths = const {},
  required String exportsTemplateFilePath,
  Set<String> pathPatterns = const {},
}) async {
  var cachedDirName = "";
  final template = await readDartTemplate(exportsTemplateFilePath);
  for (final subDirPath in subDirPaths) {
    final r = _joinPath(rootDirPath, subDirPath);
    await findDartFiles(
      rootDirPath: r,
      pathPatterns: pathPatterns,
      onFileFound: (
        _,
        __,
        final filePath,
      ) async {
        final folderName = getBaseName(r);
        final allFilePath = p.join(r, "all_$folderName.dart");
        if (r != cachedDirName) {
          cachedDirName = r;
          printGreen("Clearing `$allFilePath`...");
          final data = replaceAllData(template, {"___EXPORTS___": ""});
          await writeFile(
            allFilePath,
            data,
          );
        }
        if (filePath != allFilePath) {
          final relativeFilePath = filePath.replaceFirst(r, "");
          final data = "export '$relativeFilePath';";

          await writeFile(
            allFilePath,
            "$data\n",
            append: true,
          );
          printGreen("Writing `$data` to `$allFilePath`...");
        } else {
          printGreen("Skipping `$filePath`...");
        }
      },
    );
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _joinPath(String part1, String part2) {
  final a = () {
    if (part1.isEmpty) return part2;
    if (part2.isEmpty) return part1;
    return p.join(part1, part2);
  }();
  final b = a.endsWith(p.separator) ? a : "$a${p.separator}";
  return b;
}
