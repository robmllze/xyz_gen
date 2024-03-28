//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> analyzeModels({
  String? fallbackDartSdkPath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  void Function(String filePath, GenerateModel annotation)? onAnnotation,
}) async {
  final combinedPaths = combinePathSets([rootDirPaths, subDirPaths]);
  final collection = createAnalysisContextCollection(
    combinedPaths,
    fallbackDartSdkPath,
  );
  for (final path in combinedPaths) {
    final files = await findFiles(
      path,
      extensions: {'.dart'},
      onFileFound: (dirName, folderName, filePath) async {
        final a = isMatchingFileName(filePath, '', 'dart').$1;
        final b = isSourceDartFilePath(filePath);
        if (a && b) {
          return true;
        }
        return false;
      },
    );
    for (final filePath in files.map((e) => e.filePath)) {
      final annotation = await analyzeModelFromFile(
        collection: collection,
        inputFilePath: filePath,
      );
      if (annotation != null) {
        onAnnotation?.call(filePath, annotation);
      }
    }
  }
}
