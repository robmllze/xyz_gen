// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'utils/analyze_source_classes.dart';
import 'utils/helpers.dart';
import 'utils/list_file_paths.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModelBlahBlahs(String dirPath) async {
  final filePaths = await listFilePaths(dirPath);
  if (filePaths != null) {
    for (final filePath in filePaths) {
      final (correctFileName, fileName) = isCorrectFileName(filePath, "model", "dart");
      if (correctFileName) {
        _generateForFile(filePath);
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateModelBlahBlahs {
  final Set<String> options;
  const GenerateModelBlahBlahs({
    this.options = const {},
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(String fixedFilePath) async {
  await analyzeSourceClasses(
      filePath: fixedFilePath,
      annotationDisplayName: "GenerateModelBlahBlah",
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
