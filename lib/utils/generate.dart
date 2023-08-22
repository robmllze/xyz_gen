// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'find_files.dart';
import 'read_template.dart';
import 'helpers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generate({
  required String rootDirPath,
  required Future<void> Function(String, Map<String, String>) generateForFiles,
  required Set<String> templateFilePaths,
  String begType = "",
  Set<String> pathPatterns = const {},
  bool deleteGeneratedFiles = false,
}) async {
  if (deleteGeneratedFiles) {
    await deleteGeneratedDartFiles(rootDirPath, pathPatterns);
  }
  final templates = <String, String>{};
  for (final templateFilePath in templateFilePaths) {
    templates[templateFilePath] = await readTemplate(templateFilePath);
  }
  await findFiles(
    rootDirPath: rootDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (final dirName, final folderName, final filePath) async {
      final a = isMatchingFileName(filePath, begType, "dart").$1;
      final b = isSourceDartFilePath(filePath);
      if (a && b) {
        await generateForFiles(filePath, templates);
      }
    },
  );
}
