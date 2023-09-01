// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeups({
  String? fallbackDartSdkPath,
  required Set<String> rootPaths,
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
  required String? outputDirPath,
  required String classTemplateFilePath,
  required String builderTemplateFilePath,
  required String exportsTemplateFilePath,
}) async {
  await generateFromTemplates(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootPaths: rootPaths,
    subPaths: subPaths,
    pathPatterns: pathPatterns,
    templateFilePaths: {
      classTemplateFilePath,
      builderTemplateFilePath,
      exportsTemplateFilePath,
    },
    generateForFile: (final collection, final fixedFilePath, final templates) async {
      return _generateMakeupFile(
        collection,
        fixedFilePath,
        templates,
        outputDirPath,
      );
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateMakeupFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  Map<String, String> templates, [
  String? outputDirPath,
]) async {
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  var names = <String>{"default"};
  var parameters = <String, TypeCode>{};

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotation field.
  void onClassAnnotationField(String fieldName, DartObject fieldValue) {
    switch (fieldName) {
      case "names":
        names.addAll(
          fieldValue.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? <String>{},
        );
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
    final defaultOutputDirPath = join(classFileDirPath, "makeups");
    final classKey = className.toSnakeCase();
    final makeupClassName = "${className}Makeup";
    const makeupClassFileName = "__makeup.dart";
    final rootOutputDirPath =
        outputDirPath == null ? defaultOutputDirPath : join(outputDirPath, classKey);
    final templateData = {
      "___MAKEUP_CLASS_FILE___": makeupClassFileName,
      "___MAKEUP_CLASS___": makeupClassName,
      "___WIDGET___": className,
      "___CLASS_FILE_PATH___": fixedFilePath,
    };

    await _writeClassFile(
      join(rootOutputDirPath, "src", makeupClassFileName),
      templates.values.elementAt(0),
      templateData,
      parameters,
    );

    final exportFiles = await _writeBuilderFiles(
      makeupClassName,
      join(rootOutputDirPath, "src"),
      templates.values.elementAt(1),
      templateData,
      parameters,
      names,
      classKey,
    );

    await _writeExportsFile(
      rootOutputDirPath,
      templates.values.elementAt(2),
      templateData,
      {makeupClassFileName, ...exportFiles},
    );
  }

  // ---------------------------------------------------------------------------

  // Analyze the annotated class and generate the template files.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    collection: collection,
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
  printGreen("Generated makeup class in `${getBaseName(outputFilePath)}`");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<Set<String>> _writeBuilderFiles(
  String makeupClassName,
  String outputDirPath,
  String template,
  Map<String, String> templateData,
  Map<String, TypeCode> parameters,
  Set<String> names,
  String classKey,
) async {
  final exportFiles = <String>{};
  final makeupBuilderArgs = parameters.entries
      .map((e) => "${e.key}: null,${e.value.nullable ? "" : "// Value required!"}");
  for (final name in names) {
    final shortMakeupKey = name.toSnakeCase();
    final longMakeupKey = "${shortMakeupKey}_${classKey}_makeup";
    final outputFileName = "_$longMakeupKey.dart";
    final outputFilePath = join(outputDirPath, outputFileName);
    if (await fileExists(outputFilePath)) continue;
    final makeupBuilder = longMakeupKey.toCamelCase();
    final makeupBuilderFunction = shortMakeupKey == "default"
        ? makeupClassName
        : "${"default_${classKey}_makeup".toCamelCase()}().copyWith";
    final output = replaceAllData(template, {
      ...templateData,
      "___BUILDER___": makeupBuilder,
      "___BUILDER_FUNCTION___": makeupBuilderFunction,
      "___BUILDER_FUNCTION_ARGS___": makeupBuilderArgs.join("\n"),
    });
    await writeFile(outputFilePath, output);
    await fmtDartFile(outputFilePath);
    exportFiles.add(outputFileName);
    printGreen("Generated makeup builder in `${getBaseName(outputFilePath)}`");
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
  final outputFilePath = join(outputDirPath, "makeups.dart");
  final output = replaceAllData(template, {
    ...templateData,
    "___BODY___": exportFiles.map((e) => "export 'src/$e';").join("\n"),
  });
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
  printGreen("Generated makeup exports in `${getBaseName(outputFilePath)}`");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateMakeupsArgs extends ValidObject {
  final String? fallbackDartSdkPath;
  final String? classTemplateFilePath;
  final String? builderTemplateFilePath;
  final String? exportsTemplateFilePath;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  final String? outputDirPath;
  const GenerateMakeupsArgs({
    required this.fallbackDartSdkPath,
    required this.classTemplateFilePath,
    required this.builderTemplateFilePath,
    required this.exportsTemplateFilePath,
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
    required this.outputDirPath,
  });

  @override
  bool get valid => ValidObject.areValid([
        if (this.fallbackDartSdkPath != null) this.fallbackDartSdkPath,
        this.classTemplateFilePath,
        this.builderTemplateFilePath,
        this.exportsTemplateFilePath,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
        this.outputDirPath,
      ]);
}
