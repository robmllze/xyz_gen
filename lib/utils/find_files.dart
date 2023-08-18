// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'helpers.dart';
import 'list_file_paths.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> findFiles({
  required String startingDirPath,
  Set<String> pathPatterns = const {},
  required Future<void> Function(
    String dirName,
    String folderName,
    String filePath,
  ) onFileFound,
}) async {
  final filePaths = await listFilePaths(startingDirPath);
  if (filePaths != null) {
    for (final filePath in filePaths) {
      if (isSourceDartFilePath(filePath)) {
        final dirName = getDirName(filePath);
        final folderName = getBaseName(dirName);
        final a = pathPatterns.isEmpty || pathContainsPatterns(filePath, pathPatterns);
        if (a) {
          await onFileFound(dirName, folderName, filePath);
        }
      }
    }
  }
}
