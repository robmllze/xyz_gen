//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// X|Y|Z & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateForAnnotationTest({
  String? fallbackDartSdkPath,
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  final combinedDirPaths = combinePathSets([rootDirPaths, subDirPaths]);
  final collection =
      createAnalysisContextCollection(combinedDirPaths, fallbackDartSdkPath);
  for (final dirPath in combinedDirPaths) {
    final results = await findFiles(
      dirPath,
      extensions: {'.dart'},
      pathPatterns: pathPatterns,
    );
    for (final result in results) {
      final filePath = result.filePath;
      await _generateForFile(filePath, collection);
    }
  }
  Here().debugLogStop('Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(
  String filePath,
  AnalysisContextCollection collection,
) async {
  await analyzeAnnotatedClasses(
    filePath: filePath,
    collection: collection,
    classAnnotations: {'TestAnnotation'},
    onAnnotatedClass: (classAnnotationName, className) async {
      // Do something with the annotated class.
    },
  );
}
