//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '../../_internal_dependencies.dart';

part 'parts/_replacements.dart';
part 'parts/_generate_screen_configuration_file.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Note: Returns all the annotated screen class names.
Future<Set<String>> generateScreenConfigurations({
  String? fallbackDartSdkPath,
  required String templateFilePath,
  required Set<String> rootPaths,
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  final classNames = <String>{};
  await generateFromTemplates(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootPaths: rootPaths,
    subPaths: subPaths,
    pathPatterns: pathPatterns,
    begType: "screen",
    templateFilePaths: {templateFilePath},
    //deleteGeneratedFiles: true,
    generateForFile: (final collection, final filePath, final templates) async {
      final temp = await _generateScreenConfigurationFile(
        collection,
        filePath,
        templates,
      );
      classNames.addAll(temp);
    },
    // onDelete: (final filePath) {
    //   printLightYellow("Deleted generated file `$filePath`");
    // },
  );
  return classNames;
}
