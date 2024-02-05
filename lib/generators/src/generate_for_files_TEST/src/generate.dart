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

Future<void> generateForFiles({
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    final results = await findDartFiles(
      dirPath,
      pathPatterns: pathPatterns,
      onFileFound: (_, __, filePath) async =>
          !isGeneratedDartFilePath(filePath),
    );
    for (final result in results) {
      final filePath = result.filePath;
      await _generateForFile(filePath);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(String filePath) async {
  printGreen("[generate_from_files_TEST]: Found `${getBaseName(filePath)}`");
}