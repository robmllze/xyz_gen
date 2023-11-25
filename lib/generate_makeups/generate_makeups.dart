//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '../get_xyz_gen_lib_path.dart';
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
  required String themeTemplateFilePath,
}) async {
  final makeupBuilders = <(String, String)>{};
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
    generateForFile: (
      final collection,
      final fixedFilePath,
      final templates,
    ) async {
      await _generateMakeupFile(
        collection,
        fixedFilePath,
        templates,
        outputDirPath,
        (final a, final b) {
          printCyan(a);
          makeupBuilders.add((a, b));
        },
      );
    },
  );
  final a = makeupBuilders
      .map((e) => (e.$1.substring(0, e.$1.length - 6), e.$2))
      .map((e) => "late F${e.$2} ${e.$1};");
  final b = makeupBuilders
      .map((e) => (e.$1.substring(0, e.$1.length - 6), e.$1))
      .map((e) => "this.${e.$1} = ${e.$2};");
  final defaultTemplatesPath = join(await getXyzGenLibPath(), "templates");
  final templateFilePath = toLocalPathFormat(join(defaultTemplatesPath, themeTemplateFilePath));
  final template = await readDartTemplate(templateFilePath);
  final output = replaceAllData(template, {
    "___A___": a.join("\n  "),
    "___B___": b.join("\n    "),
  });
  await writeFile(join(outputDirPath ?? "", "theme_g.dart"), output);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateMakeupFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  Map<String, String> templates, [
  String? outputDirPath,
  void Function(String, String)? onMakeup,
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
      onMakeup,
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
    onAnnotatedClass: (final classAnnotationName, final className) async {
      // Remove the underscores at the start.
      var temp = className;
      while (temp.startsWith("_")) {
        temp = temp.substring(1);
      }
      await onAnnotatedClass(classAnnotationName, temp);
    },
    onClassAnnotationField: onClassAnnotationField,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeClassFile(
  String outputFilePath,
  String template,
  Map<String, String> templateData,
  Map<String, TypeCode> parameters,
) async {
  final entries = parameters.entries;
  final p0 = entries.map((e) => "${e.value.name} ${e.key};");
  final p1 = entries.map((e) => "${e.value.nullable ? "" : "required "}this.${e.key},");
  final p2 = entries.map((e) => "${e.value.nullableName} ${e.key},");
  final p3 = entries.map((e) => "${e.key}: ${e.key} ?? this.${e.key},");
  final output = replaceAllData(template, {
    ...templateData,
    "___P0___": p0.join("\n"),
    "___P1___": p1.join("\n"),
    "___P2___": p2.join("\n"),
    "___P3___": p3.join("\n"),
  });
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
  printGreen("Generated makeup class in `$outputFilePath`");
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
  void Function(String, String)? onMakeup,
) async {
  final exportFiles = <String>{};
  final makeupBuilderArgs = parameters.entries.map((e) => "${e.key}: null,");
  for (final name in names) {
    final shortMakeupKey = name.toSnakeCase();
    final longMakeupKey = "${classKey}_${shortMakeupKey}_makeup";
    final outputFileName = "_$longMakeupKey.dart";
    exportFiles.add(outputFileName);
    final outputFilePath = join(outputDirPath, outputFileName);
    final makeupBuilder = longMakeupKey.toCamelCase();
    onMakeup?.call(makeupBuilder, makeupClassName);
    if (await fileExists(outputFilePath)) continue;
    final defaultMakeupBuilder = "${classKey}_default_makeup".toCamelCase();
    final makeupBuilderFunction =
        shortMakeupKey == "default" ? makeupClassName : "$defaultMakeupBuilder().copyWith";
    final output = replaceAllData(template, {
      ...templateData,
      "___BUILDER___": makeupBuilder,
      "___BUILDER_FUNCTION___": makeupBuilderFunction,
      "___BUILDER_FUNCTION_ARGS___": makeupBuilderArgs.join("\n"),
    });
    await writeFile(outputFilePath, output);
    await fmtDartFile(outputFilePath);
    printGreen("Generated makeup builder in `$outputFilePath`");
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
  printGreen("Generated makeup exports in `$outputFilePath`");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateMakeupsArgs extends ValidObject {
  final String? fallbackDartSdkPath;
  final String? classTemplateFilePath;
  final String? builderTemplateFilePath;
  final String? exportsTemplateFilePath;
  final String? themeTemplateFilePath;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  final String? outputDirPath;
  const GenerateMakeupsArgs({
    required this.fallbackDartSdkPath,
    required this.classTemplateFilePath,
    required this.builderTemplateFilePath,
    required this.exportsTemplateFilePath,
    required this.themeTemplateFilePath,
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
        this.themeTemplateFilePath,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
        this.outputDirPath,
      ]);
}
