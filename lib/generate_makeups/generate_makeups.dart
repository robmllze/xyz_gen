// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils.dart';
import 'package:path/path.dart' as p;

import '../type_codes/type_codes.dart';
import '../utils/analyze_annotated_classes.dart';
import '../utils/file_io.dart';
import '../utils/generate.dart';
import '../utils/helpers.dart';
import '../utils/here.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeups({
  required String rootDirPath,
  required String? outputDirPath,
  required String classTemplateFilePath,
  required String makeupTemplateFilePath,
  required String exportsTemplateFilePath,
  Set<String> pathPatterns = const {},
}) async {
  await generate(
    rootDirPath: rootDirPath,
    templateFilePaths: {
      classTemplateFilePath,
      makeupTemplateFilePath,
      exportsTemplateFilePath,
    },
    deleteGeneratedFiles: true,
    pathPatterns: pathPatterns,
    generateForFiles: (a, b) => _generateMakeupFiles(outputDirPath, a, b),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateMakeupFiles(
  String? outputDirPath,
  String fixedFilePath,
  Map<String, String> templates,
) async {
  // ...
  var names = <String>{};
  var parameters = <String, TypeCode>{};

  // Define the function that will be called for each field in the annotation.
  void onClassAnnotationField(String fieldName, DartObject fieldValue) {
    switch (fieldName) {
      case "names":
        names =
            fieldValue.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? <String>{};
        break;
      case "parameters":
        parameters = fieldValue.toMapValue()?.map((k, v) {
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

  // ...
  var className = "";

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    classAnnotations: {"GenerateMakeups"},
    onAnnotatedClass: (_, e) {
      Here().debugLog("Generating makeup class for $e");
      className = e;
    },
    onClassAnnotationField: onClassAnnotationField,
  );

  // If className is empty, then there is no annotation in the file.
  if (className.isEmpty) return;

  // Create the actual values to replace the placeholders with.
  final classFileName = getFileName(fixedFilePath);
  final classFileDirPath = getDirPath(fixedFilePath);
  final defaultOutputDirPath = p.join(classFileDirPath, "makeups");
  final classKey = className.toSnakeCase();
  final makeupClassName = "${className}Makeup";
  const makeupFileName = "_makeup.g.dart";
  final outputDirPath0 =
      outputDirPath == null ? defaultOutputDirPath : p.join(outputDirPath, classKey);
  final outputFilePath0 = p.join(outputDirPath0, makeupFileName);
  final entries = parameters.entries;
  final p0 = entries.map((e) => "${e.value.name} ${e.key};");
  final p1 = entries.map((e) => "${e.value.nullable ? "" : "required "}this.${e.key},");
  final p2 = entries.map((e) => "${e.value.nullableName} ${e.key},");
  final p3 = entries.map((e) => "${e.key}: ${e.key} ?? this.${e.key},");

  final data0 = {
    "___MAKEUP_FILE_NAME___": makeupFileName,
    "___MAKEUP_CLASS_NAME___": makeupClassName,
    "___CLASS_FILE_NAME___": classFileName,
    "___CLASS_KEY___": classKey,
    "___CLASS_NAME___": className,
    "___P0___": p0.join("\n"),
    "___P1___": p1.join("\n"),
    "___P2___": p2.join("\n"),
    "___P3___": p3.join("\n"),
  };

  final template0 = templates.values.elementAt(0);

  // Replace placeholders with the actual values.
  final output0 = replaceAllData(
    template0,
    data0,
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath0, output0);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath0);

  final template1 = templates.values.elementAt(1);

  final a0 = entries.map((e) => "${e.key}: null,${e.value.nullable ? "" : "// Value required!"}");

  final exportFiles = <String>[makeupFileName];

  for (final name in names) {
    final makeupKey = "${name.toSnakeCase()}_${classKey}_makeup";
    final makeupBuilder = makeupKey.toCamelCase();
    final outputFileName1 = "_$makeupKey.dart";
    exportFiles.add(outputFileName1);
    final outputFilePath1 = p.join(outputDirPath0, outputFileName1);

    final output1 = replaceAllData(
      template1,
      {
        ...data0,
        "___MAKEUP_BUILDER___": makeupBuilder,
        "___MAKEUP_KEY___": makeupKey,
        "___A0___": a0.join("\n"),
      },
    );

    Here().debugLog("Generating makeup builder for $name");

    await writeFile(outputFilePath1, output1);
    await fmtDartFile(outputFilePath1);
  }

  final outputFilePath2 = p.join(outputDirPath0, "makeups.dart");
  final template2 = templates.values.elementAt(2);

  final output2 = replaceAllData(template2, {
    ...data0,
    "___EXPORTS___": exportFiles.map((e) => "export '$e';").join("\n"),
  });

  await writeFile(outputFilePath2, output2);
  await fmtDartFile(outputFilePath2);
}
