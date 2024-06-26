//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~


import 'package:path/path.dart' as p;

import 'package:xyz_utils/xyz_utils_non_web.dart' as utils;

import '/src/xyz/_all_xyz.g.dart' as xyz;

import '_analyze_dart_file.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateDartModels({
  String? fallbackDartSdkPath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templateFilePaths,
  String? output,
}) async {
  utils.debugLogStart('Starting generator. Please wait...');
  final templateProcessor = xyz.DartTemplateProcessor(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootDirPaths: rootDirPaths,
    subDirPaths: subDirPaths,
    pathPatterns: pathPatterns,
  );
  await templateProcessor.processTemplates(
    templateFilePaths: templateFilePaths,
    onSourceFile: (result) async {
      final filePath = result.source.filePath;
      final a = xyz.Lang.DART.isValidSrcFilePath(filePath);
      if (!a) return;
      await analyzeDartFile(result.context!, filePath);
    },
  );
  utils.debugLogStop('Done!');
}
