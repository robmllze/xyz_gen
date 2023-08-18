// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/utils/find_files.dart';
import 'package:xyz_utils/xyz_utils.dart';

import 'utils/analyze_source_classes.dart';
import 'utils/helpers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModelBlahBlahs(
  String startingDirPath,
  Set<String> pathPatterns,
) async {
  await findFiles(
    startingDirPath: startingDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (final dirName, final folderName, final filePath) async {
      final (correctFileName, fileName) = isCorrectFileName(filePath, "model", "dart");
      if (correctFileName) {
        await _generateForFile(filePath);
      }
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(String fixedFilePath) async {
  await analyzeSourceClasses(
      filePath: fixedFilePath,
      annotationDisplayName: "GenerateModelBlahBlahs",
      fieldNames: {"options"},
      onField: (final classDisplayName, final fieldName, final object) {
        switch (fieldName) {
          case "options":
            final options = object.toSetValue()!.map((e) => e.toStringValue()).toSet();
            print(options);
            break;
        }
      });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateModelBlahBlahs {
  final Set<String> options;
  const GenerateModelBlahBlahs({
    this.options = const {},
  });
}
