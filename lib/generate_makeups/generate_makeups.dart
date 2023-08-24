// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart';
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeups({
  required String rootDirPath,
  required String? outputDirPath,
  required String classTemplateFilePath,
  required String builderTemplateFilePath,
  required String exportsTemplateFilePath,
  Set<String> pathPatterns = const {},
}) async {
  await generateFromTemplates(
    rootDirPath: rootDirPath,
    templateFilePaths: {
      classTemplateFilePath,
      builderTemplateFilePath,
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
  final selectedOutputDirPath =
      outputDirPath == null ? defaultOutputDirPath : p.join(outputDirPath, classKey);

  final templateData = {
    "___MAKEUP_FILE_NAME___": makeupFileName,
    "___MAKEUP_CLASS_NAME___": makeupClassName,
    "___CLASS_FILE_NAME___": classFileName,
    "___CLASS_KEY___": classKey,
    "___CLASS_NAME___": className,
  };

  await _writeClassFile(
    p.join(selectedOutputDirPath, makeupFileName),
    templates.values.elementAt(1),
    templateData,
    parameters,
  );

  final exportFiles = await _writeMakeupFiles(
    selectedOutputDirPath,
    templates.values.elementAt(1),
    templateData,
    parameters,
    names,
    classKey,
  );

  await _writeExportsFile(
    selectedOutputDirPath,
    templates.values.elementAt(2),
    templateData,
    {makeupFileName, ...exportFiles},
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeClassFile(
  String outputFilePath,
  String template,
  Map<String, String> tempalteData,
  Map<String, TypeCode> parameters,
) async {
  final entries = parameters.entries;
  final p0 = entries.map((e) => "${e.value.name} ${e.key};");
  final p1 = entries.map((e) => "${e.value.nullable ? "" : "required "}this.${e.key},");
  final p2 = entries.map((e) => "${e.value.nullableName} ${e.key},");
  final p3 = entries.map((e) => "${e.key}: ${e.key} ?? this.${e.key},");
  final output = replaceAllData(template, {
    ...tempalteData,
    "___P0___": p0.join("\n"),
    "___P1___": p1.join("\n"),
    "___P2___": p2.join("\n"),
    "___P3___": p3.join("\n"),
  });
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
  Here().debugLog("Generated makeup class: $outputFilePath");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<Set<String>> _writeMakeupFiles(
  String outputDirPath,
  String template,
  Map<String, String> templateData,
  Map<String, TypeCode> parameters,
  Set<String> names,
  String classKey,
) async {
  final exportFiles = <String>{};
  final a0 = parameters.entries
      .map((e) => "${e.key}: null,${e.value.nullable ? "" : "// Value required!"}");
  for (final name in names) {
    final makeupKey = "${name.toSnakeCase()}_${classKey}_makeup";
    final makeupBuilder = makeupKey.toCamelCase();
    final outputFileName = "_$makeupKey.dart";
    exportFiles.add(outputFileName);
    final outputFilePath = p.join(outputDirPath, outputFileName);

    final output = replaceAllData(template, {
      ...templateData,
      "___MAKEUP_BUILDER___": makeupBuilder,
      "___MAKEUP_KEY___": makeupKey,
      "___A0___": a0.join("\n"),
    });
    await writeFile(outputFilePath, output);
    await fmtDartFile(outputFilePath);
    Here().debugLog("Generated makeup builder: $outputFilePath");
  }
  return exportFiles;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeExportsFile(
  String outputDirPath,
  String template,
  Map<String, String> templateData,
  Set<String> exportFiles,
) async {
  final outputFilepath = p.join(outputDirPath, "makeups.dart");
  final output = replaceAllData(template, {
    ...templateData,
    "___EXPORTS___": exportFiles.map((e) => "export '$e';").join("\n"),
  });
  await writeFile(outputFilepath, output);
  await fmtDartFile(outputFilepath);
  Here().debugLog("Generated exports file: $outputFilepath");
}
