//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// X|Y|Z & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeups({
  String? fallbackDartSdkPath,
  required Set<String> rootPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathDirPatterns = const {},
  required String? outputDirPath,
  required String classTemplateFilePath,
  required String builderTemplateFilePath,
  required String generatedThemeTemplateFilePath,
  required String generateTemplateFilePath,
}) async {
  Here().debugLogStart("Starting generator. Please wait...");
  final exportFilesBuffer = <String, Set<String>>{};
  final makeupBuilderNameArgs = <(String, String)>{};
  await generateFromTemplates(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootDirPaths: rootPaths,
    subDirPaths: subDirPaths,
    pathPatterns: pathDirPatterns,
    templateFilePaths: {
      classTemplateFilePath,
      builderTemplateFilePath,
      generatedThemeTemplateFilePath,
      generateTemplateFilePath,
    },
    generateForFile: (
      collection,
      fixedFilePath,
      templates,
    ) async {
      await _generateMakeupFile(
        collection,
        fixedFilePath,
        generateTemplateFilePath,
        templates,
        exportFilesBuffer,
        outputDirPath,
        (makeupBuilder, makeupClassName) {
          makeupBuilderNameArgs.add((makeupBuilder, makeupClassName));
        },
      );
    },
  );

  // Generate the theme class.
  {
    final declarationParts = makeupBuilderNameArgs
        .map((e) => (e.$1.substring(0, e.$1.length - 6), e.$2))
        .map((e) => "late F${e.$2} ${e.$1};");
    final initializationParts = makeupBuilderNameArgs
        .map((e) => (e.$1.substring(0, e.$1.length - 6), e.$1))
        .map((e) => "this.${e.$1} = ${e.$2};");
    final template =
        (await readSnippetsFromMarkdownFile(generatedThemeTemplateFilePath))
            .join("\n");
    final output = replaceData(template, {
      "___DECLARTION_PART___": declarationParts.join("\n  "),
      "___INITIALIZATION_PART___": initializationParts.join("\n    "),
    });
    final outputFilePath = p.join(outputDirPath ?? "", "makeup_theme.g.dart");
    await writeFile(outputFilePath, output);
    await fmtDartFile(outputFilePath);
  }
  Here().debugLogStop("Done!");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateMakeupFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  String generateTemplateFilePath,
  Map<String, String> templates,
  Map<String, Set<String>> exportFilesBuffer, [
  String? outputDirPath,
  void Function(String, String)? onNamingMakeupBuilder,
]) async {
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  final variants = <String>{"default"};
  final properties = <String, TypeCode>{};

  // ---------------------------------------------------------------------------

  Future<void> writeGenerateFile(
    String classKey,
    String rootOutputDirPath,
    String annotatedClassName,
  ) async {
    final outputFilePath = p.join(rootOutputDirPath, "_generate_makeups.dart");
    if (!await fileExists(outputFilePath)) {
      final template = templates.values.elementAt(3);
      final outputData = replaceData(template, {
        "___CLASS___": annotatedClassName,
      });

      await writeFile(outputFilePath, outputData);
      await fmtDartFile(outputFilePath);
    }
  }

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotated class.
  Future<void> onAnnotatedClass(
    String _,
    String className,
    Map<String, Set<String>> exportFilesBuffer,
  ) async {
    final classFileDirPath = getDirPath(fixedFilePath);
    final defaultOutputDirPath = p.join(classFileDirPath, "makeups");
    final classKey = className.toSnakeCase();
    final makeupClassName = "${className}Makeup";
    final actualClassFileName =
        p.join(fixedFilePath).split(p.separator).last.toLowerCase();
    final desiredClassFileName = "$classKey.dart";
    final hasCorrectFileName = actualClassFileName == desiredClassFileName;
    final makeupClassFileName = "${classKey}_makeup.g.dart";
    final rootOutputDirPath = outputDirPath == null
        ? defaultOutputDirPath
        : p.join(outputDirPath, classKey);
    final templateData = {
      "___MAKEUP_CLASS_FILE___": makeupClassFileName,
      "___CLASS_FILE___": desiredClassFileName,
      "___MAKEUP_CLASS___": makeupClassName,
      "___CLASS___": className,
      "___PROPERTIES___": [
        properties.entries
            .map((e) => '"${e.key}": "${e.value.nullableName}"')
            .join(","),
      ].map((e) => e.isEmpty ? "" : "$e,").first,
    };

    if (hasCorrectFileName) {
      await _writeClassFile(
        p.join(classFileDirPath, makeupClassFileName),
        templates.values.elementAt(0),
        templateData,
        properties,
      );
    }

    await _writeBuilderFiles(
      makeupClassName,
      p.join(rootOutputDirPath, "makeups"),
      templates.values.elementAt(1),
      templateData,
      properties,
      variants,
      classKey,
      onNamingMakeupBuilder,
    );

    await writeGenerateFile(
      classKey,
      rootOutputDirPath,
      className,
    );
  }

  // ---------------------------------------------------------------------------

  // Analyze the annotated class and generate the template files.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    collection: collection,
    memberAnnotations: {"Property"},
    onAnnotatedMember: (memberAnnotationName, memberName, memberType) async {
      if (memberAnnotationName == "Property") {
        properties.addAll({
          memberName: TypeCode(memberType),
        });
      }
    },
    classAnnotations: {"GenerateMakeups"},
    onAnnotatedClass: (classAnnotationName, className) async {
      // Remove the underscores at the start.
      var temp = className;
      while (temp.startsWith("_")) {
        temp = temp.substring(1);
      }

      await onAnnotatedClass(
        classAnnotationName,
        temp,
        exportFilesBuffer,
      );
    },
    onClassAnnotationField: (fieldName, fieldValue) {
      switch (fieldName) {
        case "variants":
          variants.addAll(
            fieldValue
                    .toSetValue()
                    ?.map((e) => e.toStringValue())
                    .nonNulls
                    .toSet() ??
                <String>{},
          );
          break;

        case "properties":
          properties.addAll(
            fieldValue.toMapValue()?.map((k, v) {
                  final typeCode = v?.toStringValue();
                  return MapEntry(
                    k?.toStringValue(),
                    typeCode != null ? TypeCode(typeCode) : null,
                  );
                }).nonNulls ??
                {},
          );
          break;
      }
    },
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
  final p0 = entries.map((e) => "${e.value.getName()} ${e.key};");
  final p1 = entries
      .map((e) => "${e.value.nullable ? "" : "required "}this.${e.key},");
  final p2 = entries.map((e) => "${e.value.nullableName} ${e.key},");
  final p3 = entries.map((e) => "${e.key}: ${e.key} ?? this.${e.key},");
  final output = replaceData(template, {
    ...templateData,
    "___P0___": p0.isNotEmpty ? p0.join("\n") : "// TODO: Add parameters here.",
    "___P1___": p1.isNotEmpty ? "{${p1.join("\n")}}" : "",
    "___P2___": p2.isNotEmpty ? "{${p2.join("\n")}}" : "",
    "___P3___": p3.join("\n"),
  });
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeBuilderFiles(
  String makeupClassName,
  String outputDirPath,
  String template,
  Map<String, String> templateData,
  Map<String, TypeCode> parameters,
  Set<String> names,
  String classKey,
  void Function(String, String)? onNamingMakeupBuilder,
) async {
  final makeupBuilderArgs = parameters.entries.map((e) => "${e.key}: null,");
  for (final name in names) {
    final shortMakeupKey = name.toSnakeCase();
    final longMakeupKey = "${classKey}_${shortMakeupKey}_makeup";
    final outputFileName = "$longMakeupKey.dart";
    final outputFilePath = p.join(outputDirPath, outputFileName);
    final makeupBuilder = longMakeupKey.toCamelCase();
    onNamingMakeupBuilder?.call(makeupBuilder, makeupClassName);
    if (await fileExists(outputFilePath)) continue;
    final defaultMakeupBuilder = "${classKey}_default_makeup".toCamelCase();
    final makeupBuilderFunction = shortMakeupKey == "default"
        ? makeupClassName
        : "$defaultMakeupBuilder().copyWith";
    final output = replaceData(template, {
      ...templateData,
      "___BUILDER___": makeupBuilder,
      "___BUILDER_FUNCTION___": makeupBuilderFunction,
      "___BUILDER_FUNCTION_ARGS___": makeupBuilderArgs.join("\n"),
    });
    await writeFile(outputFilePath, output);
    await fmtDartFile(outputFilePath);
  }
}
