// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: constant_identifier_names, avoid_print

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart';
import 'package:path/path.dart' as p;

part 'parts/_replacements.dart';
part 'parts/_generate_screen_configuration_file.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenConfigurations({
  required String rootDirPath,
  required String templateFilePath,
  Set<String> pathPatterns = const {},
}) async {
  await generateFromTemplates(
    begType: "screen",
    rootDirPath: rootDirPath,
    templateFilePaths: {templateFilePath},
    deleteGeneratedFiles: true,
    pathPatterns: pathPatterns,
    generateForFiles: _generateScreenConfigurationFile,
    onDelete: (final filePath) {
      printLightYellow("Deleted generated file `$filePath`");
    },
  );
}
