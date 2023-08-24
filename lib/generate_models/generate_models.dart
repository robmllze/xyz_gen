// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: unnecessary_this, avoid_print

import 'package:analyzer/dart/constant/value.dart';
import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils_non_web.dart';

export 'annotation.dart';
export 'model.dart';

part 'parts/_generate_model_file.dart';
part 'parts/_helpers.dart';
part 'parts/_replacements.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModels({
  required String rootDirPath,
  required String templateFilePath,
  Set<String> pathPatterns = const {},
}) async {
  await generateFromTemplates(
    begType: "model",
    rootDirPath: rootDirPath,
    templateFilePaths: {templateFilePath},
    deleteGeneratedFiles: true,
    pathPatterns: pathPatterns,
    generateForFiles: _generateModelFile,
  );
}
