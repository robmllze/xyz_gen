// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '../generate_models.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateModelFile(
  String fixedFilePath,
  Map<String, String> template,
) async {
  // ...
  var className = "";
  String? collectionPath;
  var parameters = <String, TypeCode>{};

  // Define the function that will be called for each field in the annotation.
  void onClassAnnotationField(String fieldName, DartObject fieldValue) {
    switch (fieldName) {
      case "className":
        className = fieldValue.toStringValue() ?? "";
        break;
      case "collectionPath":
        collectionPath = fieldValue.toStringValue();
        break;
      case "parameters":
        parameters = fieldValue.toMapValue()?.map((k, v) {
              final t = v?.toStringValue();
              return MapEntry(
                k?.toStringValue(),
                t != null ? TypeCode(t) : null,
              );
            }).nonNulls ??
            {};
        break;
    }
  }

  // ...
  var sourceClassName = "";

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    classAnnotations: {"GenerateModel"},
    onAnnotatedClass: (_, e) {
      sourceClassName = e;
      Here().debugLog("Generating model for $e");
    },
    onClassAnnotationField: onClassAnnotationField,
  );

  // If className is empty, then there is no annotation in the file.
  if (className.isEmpty) return;

  // Create the actual values to replace the placeholders with.
  final classFileName = getFileName(fixedFilePath);
  final classFileDirPath = getDirPath(fixedFilePath);
  final classKey = getFileNameWithoutExtension(classFileName);
  final outputFileName = "$classKey.g.dart";
  final outputFilePath = p.join(classFileDirPath, outputFileName);

  // Replace placeholders with the actual values.
  final output = replaceAllData(
    template.values.first,
    {
      "___CLASS_NAME___": className,
      "___SOURCE_CLASS___": sourceClassName,
      "___CLASS_FILE_NAME___": classFileName,
      "___COLLECTION_PATH___": collectionPath,
      ..._replacements(parameters),
    },
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath, output);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath);
}
