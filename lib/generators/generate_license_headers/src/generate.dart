//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/utils/src/dart_files.dart';
import '/utils/all_utils.g.dart';
import 'package:xyz_utils/shared/all_shared.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateLicenseHeaders({
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required String templateFilePath,
}) async {
  final template =
      (await readDartSnippetsFromMarkdownFile(templateFilePath)).join("\n");
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    final results = await findDartFiles(
      dirPath,
      pathPatterns: pathPatterns,
      onFileFound: (_, __, filePath) async =>
          !isGeneratedDartFilePath(filePath),
    );
    for (final result in results) {
      final filePath = result.filePath;
      await _generateForFile(filePath, template);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(String filePath, String template) async {
  final lines = (await readFileAsLines(filePath))!;
  if (lines.isNotEmpty) {
    var n = 0;
    for (n; n < lines.length; n++) {
      final line = lines[n].trim();
      if (line.isNotEmpty && !line.startsWith("//")) {
        break;
      }
    }
    final withoutHeader = lines.sublist(n).join("\n");
    final withHeader = "${template.trim()}\n\n$withoutHeader";
    printGreen("Generated license header for `${getBaseName(filePath)}`");
    await writeFile(filePath, withHeader);
  }
}
