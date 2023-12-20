//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen / XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

import 'package:path/path.dart' as p;

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
  final combinedPaths = getAllPathCombinations([rootPaths, subPaths]);
  final collection = _createCollection(
    combinedPaths,
    fallbackDartSdkPath,
  );
  if (deleteGeneratedFiles) {
    for (final path in combinedPaths) {
      await deleteGeneratedDartFiles(
        path,
        onDelete: onDelete,
        pathPatterns: pathPatterns,
      );
    }
  }
  for (final path in combinedPaths) {
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Creates an [AnalysisContextCollection] from a set of paths. This is used to
// analyze Dart files. The [fallbackDartSdkPath] is used if the `DART_SDK`
// environment variable is not set.
AnalysisContextCollection _createCollection(
  Set<String> paths,
  String? fallbackDartSdkPath,
) {
  final sdkPath = Platform.environment["DART_SDK"] ?? fallbackDartSdkPath;
  final includePaths = paths.map((e) => p.normalize(p.absolute(e))).toList();
  final collection = AnalysisContextCollection(
    includedPaths: includePaths,
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    sdkPath: sdkPath,
  );
  return collection;
}
