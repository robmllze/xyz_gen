//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:analyzer/dart/constant/value.dart';
import 'package:path/path.dart' as p;

import '/_common.dart';

part 'generate_parts/_generate_screen_bindings_file.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Note: Returns all the annotated screen class names.
Future<Set<String>> generateScreenBindings({
  String? fallbackDartSdkPath,
  required String templateFilePath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  final classNames = <String>{};
  await generateFromTemplates(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootDirPaths: rootDirPaths,
    subDirPaths: subDirPaths,
    pathPatterns: pathPatterns,
    templateFilePaths: {templateFilePath},
    generateForFile: (collection, filePath, templates) async {
      final temp = await _generateForFile(
        collection,
        filePath,
        templates,
      );
      classNames.addAll(temp);
    },
  );
  Here().debugLogStop('Done!');
  return classNames;
}
