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
  await deleteGeneratedDartFiles(
    outputDirPath ?? rootDirPath,
    onDelete: (final filePath) {
      printLightYellow("Deleted generated file `$filePath`");
    },
  );
  await generateFromTemplates(
    rootDirPath: rootDirPath,
    templateFilePaths: {
      classTemplateFilePath,
      builderTemplateFilePath,
      exportsTemplateFilePath,
    },
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
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  var names = <String>{};
  var parameters = <String, TypeCode>{};

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotation field.
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

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotated class.
  Future<void> onAnnotatedClass(String _, String className) async {
    final classFileDirPath = getDirPath(fixedFilePath);
    final defaultOutputDirPath = p.join(classFileDirPath, "makeups");
    final classKey = className.toSnakeCase();
    final makeupClassName = "${className}Makeup";
    const makeupClassFileName = "_makeup.g.dart";
    final selectedOutputDirPath =
        outputDirPath == null ? defaultOutputDirPath : p.join(outputDirPath, classKey);
    final templateData = {
      "___MAKEUP_CLASS_FILE___": makeupClassFileName,
      "___MAKEUP_CLASS___": makeupClassName,
      "___WIDGET___": className,
      "___CLASS_FILE_PATH___": fixedFilePath,
    };

    final outputFilePath = p.join(selectedOutputDirPath, makeupClassFileName);

    await _writeClassFile(
      outputFilePath,
      templates.values.elementAt(0),
      templateData,
      parameters,
    );

    final exportFiles = await _writeBuilderFiles(
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
      {makeupClassFileName, ...exportFiles},
    );
  }

  // ---------------------------------------------------------------------------

  // Analyze the annotated class and generate the template files.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    classAnnotations: {"GenerateMakeups"},
    onAnnotatedClass: onAnnotatedClass,
    onClassAnnotationField: onClassAnnotationField,
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
  printGreen("Generated makeup class `$outputFilePath`");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<Set<String>> _writeBuilderFiles(
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

    if (await fileExists(outputFilePath)) continue;

    final output = replaceAllData(template, {
      ...templateData,
      "___MAKEUP_BUILDER___": makeupBuilder,
      "___MAKEUP_BUILDER_ARGS___": a0.join("\n"),
    });
    await writeFile(outputFilePath, output);
    await fmtDartFile(outputFilePath);
    printGreen("Generated makeup builder `$outputFilePath`");
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
  printGreen("Generated makeup exports `$outputFilepath`");
}
