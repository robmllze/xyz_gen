//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateForAnnotationTest({
  String? fallbackDartSdkPath,
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  final paths = combinePathSets([rootDirPaths, subDirPaths]);
  final collection = createAnalysisContextCollection(paths, fallbackDartSdkPath);
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    final results = await findDartFiles(
      dirPath,
      pathPatterns: pathPatterns,
    );
    for (final result in results) {
      final filePath = result.filePath;
      await _generateForFile(filePath, collection);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(
  String filePath,
  AnalysisContextCollection collection,
) async {
  await analyzeAnnotatedClasses(
    filePath: filePath,
    collection: collection,
    classAnnotations: {"TestAnnotation"},
    onAnnotatedClass: (final classAnnotationName, final className) async {
      printGreen(
        "[generate_from_annotation_TEST]: Found $className annotated with $classAnnotationName at `${getBaseName(filePath)}`",
      );
    },
  );
}
