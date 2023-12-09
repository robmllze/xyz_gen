//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

import '../gen_utils_non_web.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateFromTemplates({
  String? fallbackDartSdkPath,
  required Set<String> rootPaths,
  Set<String> subPaths = const {},
  required Future<void> Function(
    AnalysisContextCollection collection,
    String filePath,
    Map<String, String> templates,
  ) generateForFile,
  required Set<String> templateFilePaths,
  String begType = "",
  Set<String> pathPatterns = const {},
  bool deleteGeneratedFiles = false,
  void Function(String filePath)? onDelete,
}) async {
  printYellow("Starting generator. Please wait...");
  final combinedPaths = combinePaths([rootPaths, subPaths]);
  final collection = createCollection(
    combinedPaths,
    fallbackDartSdkPath,
  );
  for (final path in combinedPaths) {
    if (deleteGeneratedFiles) {
      await deleteGeneratedDartFiles(
        path,
        onDelete: onDelete,
        pathPatterns: pathPatterns,
      );
    }
    final templates = <String, String>{};
    for (final templateFilePath in templateFilePaths) {
      templates[templateFilePath] = await readDartTemplate(templateFilePath);
    }
    final results = await findDartFiles(
      path,
      pathPatterns: pathPatterns,
      onFileFound: (final dirName, final folderName, final filePath) async {
        final a = isMatchingFileName(filePath, begType, "dart").$1;
        final b = isSourceDartFilePath(filePath);
        if (a && b) {
          return true;
        }
        return false;
      },
    );
    for (final result in results) {
      final filePath = result.$3;
      await generateForFile(collection, filePath, templates);
    }
  }
  printYellow("[DONE]");
}
