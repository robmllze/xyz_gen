// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_utils/xyz_utils.dart';

import 'utils/file_io.dart';
import 'utils/find_files.dart';
import 'utils/analyze_source_classes.dart';
import 'utils/get_templates_from_md.dart';
import 'utils/helpers.dart';
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModelBlahBlahs(
  String rootDirPath, {
  Set<String> pathPatterns = const {},
  bool deleteGeneratedFiles = false,
}) async {
  if (deleteGeneratedFiles) {
    await deleteGeneratedDartFiles(rootDirPath, pathPatterns);
  }
  final templates = await getTemplatesFromMd("./templates/model_templates.md");
  await findFiles(
    rootDirPath: rootDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (final dirName, final folderName, final filePath) async {
      final (a, _) = isMatchingFileName(filePath, "model", "dart");
      final b = isSourceDartFilePath(filePath);
      final c = a && b;
      if (c) {
        await _generateForFile(filePath, templates.toList());
      }
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(
  String fixedFilePath,
  List<String> templates,
) async {
  Set<String>? options;
  String? className;
  await analyzeAnnotatedClasses(
      filePath: fixedFilePath,
      annotationName: "GenerateModelBlahBlahs",
      fieldNames: {"options"},
      onClass: (e) => className = e,
      onField: (final fieldName, final object) {
        switch (fieldName) {
          case "options":
            options = object.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? {};
            break;
        }
      });

  for (var n = 0; n < templates.length; n++) {
    final template = templates[n];
    final baseName = getFileName(fixedFilePath);
    final a = getFileNameWithoutExtension(getFileName(fixedFilePath));
    final b = n == 0 ? "$a.g.dart" : "_${n}_$a.g.dart";
    final c = getDirPath(fixedFilePath);
    final d = p.join(c, b);
    final output = replaceAllData(
      template,
      {
        "___CLASS___": className ?? "___CLASS___",
        "___CLASS_FILE___": baseName,
      },
    );
    await writeFile(d, output);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateModelBlahBlahs {
  final Set<String> options;
  const GenerateModelBlahBlahs({
    this.options = const {},
  });
}
