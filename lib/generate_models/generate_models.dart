// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';

export 'annotation.dart';
export 'model.dart';

part 'parts/_generate_model_file.dart';
part 'parts/_helpers.dart';
part 'parts/_replacements.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModels({
  required Set<String> rootPaths,
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
  required String templateFilePath,
}) async {
  await generateFromTemplates(
    rootPaths: rootPaths,
    subPaths: subPaths,
    pathPatterns: pathPatterns,
    begType: "model",
    templateFilePaths: {templateFilePath},
    //deleteGeneratedFiles: true,
    generateForFile: _generateModelFile,
    // onDelete: (final filePath) {
    //   printLightYellow("Deleted generated file `$filePath`");
    // },
  );
}
