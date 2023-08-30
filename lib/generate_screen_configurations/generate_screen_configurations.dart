// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';

part 'parts/_replacements.dart';
part 'parts/_generate_screen_configuration_file.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenConfigurations({
  required String templateFilePath,
  required Set<String> rootPaths,
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  await generateFromTemplates(
    rootPaths: rootPaths,
    subPaths: subPaths,
    pathPatterns: pathPatterns,
    begType: "screen",
    templateFilePaths: {templateFilePath},
    //deleteGeneratedFiles: true,
    generateForFile: _generateScreenConfigurationFile,
    // onDelete: (final filePath) {
    //   printLightYellow("Deleted generated file `$filePath`");
    // },
  );
}
