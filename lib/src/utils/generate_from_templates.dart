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

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A helper for generating code from templates.
///
/// - [fallbackDartSdkPath] is used if the `DART_SDK` environment variable is not
/// automatically detected.
/// - [rootDirPaths] is a set of paths to search for Dart files.
/// - [subDirPaths] is a subset of paths to search for Dart files.
/// - [generateForFile] is a function that is called for each Dart file found.
/// - [templateFilePaths] is a set of paths to Markdown files that contain
/// templates used by [generateForFile].
/// - [begType] is a string that is used to filter the Dart files found.
/// - [pathPatterns] is a set of patterns used to filter the Dart files found.
/// - [deleteGeneratedFiles] can be set to `true` to delete generated files.
/// - [onDelete] is a callback that is called when a file is deleted.
Future<void> generateFromTemplates({
  String? fallbackDartSdkPath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  required Future<void> Function(
    AnalysisContextCollection collection,
    String filePath,
    Map<String, String> templates,
  ) generateForFile,
  required Set<String> templateFilePaths,
  String begType = '',
  Set<String> pathPatterns = const {},
  bool deleteGeneratedFiles = false,
  void Function(String filePath)? onDelete,
}) async {
  final combinedPaths = combinePathSets([rootDirPaths, subDirPaths]);
  final collection = createAnalysisContextCollection(
    combinedPaths,
    fallbackDartSdkPath,
  );
  if (deleteGeneratedFiles) {
    for (final dirPath in combinedPaths) {
      await deleteGeneratedDartFiles(
        dirPath,
        onDelete: onDelete,
        pathPatterns: pathPatterns,
      );
    }
  }
  for (final path in combinedPaths) {
    final templates = <String, String>{};
    for (final templateFilePath in templateFilePaths) {
      templates[templateFilePath] =
          (await readSnippetsFromMarkdownFile(templateFilePath)).join('\n');
    }
    final results = await findFiles(
      path,
      extensions: {'.dart'},
      pathPatterns: pathPatterns,
      onFileFound: (dirName, folderName, filePath) async {
        final a = isMatchingFileName(filePath, begType, 'dart').$1;
        final b = isSourceDartFilePath(filePath);
        if (a && b) {
          return true;
        }
        return false;
      },
    );
    for (final result in results) {
      final filePath = result.filePath;
      await generateForFile(collection, filePath, templates);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Creates an [AnalysisContextCollection] from a set of paths. This is used to
/// analyze Dart files. The [fallbackDartSdkPath] is used if the `DART_SDK`
/// environment variable is not set.
AnalysisContextCollection createAnalysisContextCollection(
  Set<String> paths,
  String? fallbackDartSdkPath,
) {
  final sdkPath = Platform.environment['DART_SDK'] ?? fallbackDartSdkPath;
  final includePaths = paths.map((e) => p.normalize(p.absolute(e))).toList();
  final collection = AnalysisContextCollection(
    includedPaths: includePaths,
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    sdkPath: sdkPath,
  );
  return collection;
}
