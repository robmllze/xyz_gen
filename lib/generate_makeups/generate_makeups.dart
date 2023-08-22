// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils.dart';
import 'package:path/path.dart' as p;

import '../type_codes/type_codes.dart';
import '../utils/analyze_source_classes.dart';
import '../utils/file_io.dart';
import '../utils/generate.dart';
import '../utils/helpers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _ANNOTATION_NAME = "GenerateMakeups";
const _K_NAMES = "names";
const _K_PARAMETERS = "parameters";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeups({
  required String rootDirPath,
  required Set<String> templateFilePaths,
  Set<String> pathPatterns = const {},
}) async {
  await generate(
    rootDirPath: rootDirPath,
    templateFilePaths: templateFilePaths,
    deleteGeneratedFiles: true,
    pathPatterns: pathPatterns,
    generateForFiles: _generateMakeupFiles,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateMakeupFiles(
  String fixedFilePath,
  Map<String, String> templates,
) async {
  var className = "";
  var names = <String>{};
  var parameters = <String, TypeCode>{};

  void onField(String fieldName, DartObject object) {
    switch (fieldName) {
      case _K_NAMES:
        names = object.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? <String>{};
        break;
      case _K_PARAMETERS:
        parameters = object.toMapValue()?.map((k, v) {
              final typeCode = v?.toStringValue();
              return MapEntry(
                k?.toStringValue(),
                typeCode != null ? TypeCode(typeCode) : null,
              );
            }).nonNulls ??
            {};
        break;
    }
  }

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    annotationName: _ANNOTATION_NAME,
    fieldNames: {
      _K_NAMES,
      _K_PARAMETERS,
    },
    onClass: (e) {
      className = e;
    },
    onField: onField,
  );

  // Create the actual values to replace the placeholders with.
  final classFileName = getFileName(fixedFilePath);
  final classFileDirPath = getDirPath(fixedFilePath);
  final classKey = getFileNameWithoutExtension(classFileName);
  final outputFileName = "$classKey.g.dart";
  final outputFilePath = p.join(classFileDirPath, outputFileName);

  final entries = parameters.entries;
  final p0 = entries.map((e) => "${e.value.name} ${e.key};");
  final p1 = entries.map((e) => "${e.value.nullable ? "" : "required "}this.${e.key},");
  final p2 = entries.map((e) => "${e.value.nullableName} ${e.key},");
  final p3 = entries.map((e) => "${e.key}: ${e.key} ?? this.${e.key},");

  // Replace placeholders with the actual values.
  final output = replaceAllData(
    templates.values.first,
    {
      "___MAKEUP_CLASS___": "${className}Makeup",
      "___CLASS_FILE___": classFileName,
      "___CLASS___": className,
      "___P0___": p0.join("\n"),
      "___P1___": p1.join("\n"),
      "___P2___": p2.join("\n"),
      "___P3___": p3.join("\n"),
    },
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath, output);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath);

  for (final name in names) {
    final makeupKey = name.toSnakeCase();
    final makeupFilePath = p.join(classFileDirPath, "$classKey$makeupKey.dart");

    final output = replaceAllData(
      templates.keys.first,
      {
        "___MAKEUP_CLASS___": "${className}Makeup",
        "___CLASS_FILE___": classFileName,
        "___CLASS___": className,
        "___CLASS_KEY___": classKey,
        "___MAKEUP_KEY___": makeupKey,
      },
    );

    await writeFile(makeupFilePath, output);
    await fmtDartFile(makeupFilePath);
  }
}
