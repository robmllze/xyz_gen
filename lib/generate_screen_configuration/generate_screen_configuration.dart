// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: constant_identifier_names, avoid_print

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils.dart';

import '/utils/generate.dart';
import '/utils/file_io.dart';
import '/utils/analyze_source_classes.dart';
import '/utils/helpers.dart';
import 'package:path/path.dart' as p;

part 'parts/_replacements.dart';
part 'parts/_generate_screen_configuration_file.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenConfiguration({
  required String rootDirPath,
  required String templateFilePath,
  Set<String> pathPatterns = const {},
}) async {
  await generate(
    begType: "screen",
    rootDirPath: rootDirPath,
    templateFilePath: templateFilePath,
    deleteGeneratedFiles: true,
    pathPatterns: pathPatterns,
    generateForFile: _generateScreenConfigurationFile,
  );
}
