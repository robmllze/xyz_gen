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
  String startingDirPath,
  Set<String> pathPatterns,
) async {
  final templates = await getTemplatesFromMd("./templates/model_templates.md");
  await findFiles(
    startingDirPath: startingDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (final dirName, final folderName, final filePath) async {
      final (a, _) = isCorrectFileName(filePath, "model", "dart");
      final b = isSourceDartFilePath(filePath);
      final c = a && b;
      if (c) {
        await _generateForFile(filePath, templates);
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
      annotationDisplayName: "GenerateModelBlahBlahs",
      fieldNames: {"options"},
      onField: (final classDisplayName, final fieldName, final object) {
        className = classDisplayName;
        switch (fieldName) {
          case "options":
            options = object.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? {};
            break;
        }
      });

  for (var n = 0; n < templates.length; n++) {
    final template = templates[n];
    final baseName = getBaseName(fixedFilePath);
    final a = getFileNameWithoutExtension(getBaseName(fixedFilePath));
    final b = n == 0 ? "$a.g.dart" : "_${n}_$a.g.dart";
    final c = getDirName(fixedFilePath);
    final d = p.join(c, b);
    final output = replaceAllData(
      template,
      {
        "___CLASS_NAME___": className ?? "___CLASS_NAME___",
        "___SOURCE_BASE_NAME__": baseName,
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
