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

part of '../generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateModelForFile(
  AnalysisContextCollection collection,
  String inputFilePath,
  Map<String, String> templates,
) async {
  var annotation = const GenerateModel();
  // Analyze the annotated class and generate the model file.
  await analyzeAnnotatedClasses(
    filePath: inputFilePath,
    collection: collection,
    // Call for each annotated class.
    onAnnotatedClass: (
      classAnnotationName,
      annotatedClassName,
    ) async {
      annotation = await generateModel(
        inputFilePath: inputFilePath,
        templates: templates,
        annotation: annotation,
        annotatedClassName: annotatedClassName,
      );
    },
    // Allow the following class annotations:
    classAnnotations: {"GenerateModel"},
    // Call for each field in the annotation.
    onClassAnnotationField: (fieldName, fieldValue) {
      annotation = _updateFromClassAnnotationField(
        annotation,
        fieldName,
        fieldValue,
      );
    },
    // Call for each annotated member.
    onAnnotatedMember: (
      memberAnnotationName,
      memberName,
      memberType,
    ) {
      annotation = _updateFromAnnotatedMember(
        annotation,
        memberAnnotationName,
        memberName,
        memberType,
      );
    },
    // Allow the following member annotations.
    memberAnnotations: {"Field"},
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<GenerateModel> generateModel({
  required String inputFilePath,
  required Map<String, String> templates,
  required GenerateModel annotation,
  required String annotatedClassName,
}) async {
  // Decide on the class name.
  final a = annotatedClassName.replaceFirst(RegExp(r"^[_$]+"), "");
  final b = a != annotatedClassName ? a : "${annotatedClassName}Model";
  annotation = annotation.copyWith(
    className:
        annotation.className?.nullIfEmpty == null ? b : annotation.className,
  );

  // Get the class file name from the file path.
  final classFileName = getBaseName(inputFilePath);

  // Replace placeholders with the actual values.
  final template = templates.values.first;
  final output = replaceAllData(
    template,
    {
      "___SUPER_CLASS___":
          annotation.shouldInherit ? annotatedClassName : "Model",
      "___SUPER_CONSTRUCTOR___": annotation.shouldInherit
          ? annotation.inheritanceConstructor?.nullIfEmpty != null
              ? ": super.${annotation.inheritanceConstructor}()"
              : ""
          : "",
      "___CLASS___": annotation.className,
      "___MODEL_ID___": annotation.className?.toLowerSnakeCase(),
      "___CLASS_FILE_NAME___": classFileName,
      ..._replacements(
        fields:
            annotation.fields?.map((k, v) => MapEntry(k, TypeCode(v))) ?? {},
        keyStringCaseType:
            StringCaseType.values.valueOf(annotation.keyStringCase) ??
                StringCaseType.LOWER_SNAKE_CASE,
        includeId: annotation.includeId,
        includeArgs: annotation.includeArgs,
      ),
    },
  );

  // Get the output file path.
  final outputFilePath = () {
    final classFileDirPath = getDirPath(inputFilePath);
    final classKey = getFileNameWithoutExtension(classFileName);
    final outputFileName = "_$classKey.g.dart";
    return p.join(classFileDirPath, outputFileName);
  }();

  // Write the generated Dart file.
  await writeFile(outputFilePath, output);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath);

  // Log the generated file.
  printGreen(
      "Generated `${annotation.className}` in `${getBaseName(outputFilePath)}`");
  return annotation;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateModel _updateFromAnnotatedMember(
  GenerateModel annotation,
  String memberAnnotationName,
  String memberName,
  String memberType,
) {
  if (memberAnnotationName == "Field") {
    annotation = annotation.copyWith(
      fields: {
        ...?annotation.fields,
        memberName: memberType,
      },
    );
  }
  return annotation;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateModel _updateFromClassAnnotationField(
  GenerateModel annotation,
  String fieldName,
  DartObject fieldValue,
) {
  switch (fieldName) {
    case "className":
      return annotation.copyWith(
        className: fieldValue.toStringValue() ?? "",
      );

    case "fields":
      return annotation.copyWith(
        fields: {
          ...?annotation.fields,
          ...fieldValue.toMapValue()?.map((k, v) {
                return MapEntry(
                  k?.toStringValue(),
                  v?.toStringValue(),
                );
              }).nonNulls ??
              {},
        },
      );

    case "shouldInherit":
      return annotation.copyWith(
        shouldInherit: fieldValue.toBoolValue() ?? false,
      );
    case "inheritanceConstructor":
      return annotation.copyWith(
        inheritanceConstructor: fieldValue.toStringValue() ?? "",
      );

    case "keyStringCase":
      return annotation.copyWith(
        keyStringCase:
            fieldValue.toStringValue() ?? StringCaseType.LOWER_SNAKE_CASE.name,
      );

    case "includeId":
      return annotation.copyWith(
        includeId: fieldValue.toBoolValue() ?? true,
      );

    case "includeArgs":
      return annotation.copyWith(
        includeArgs: fieldValue.toBoolValue() ?? true,
      );
    default:
      return annotation;
  }
}
