// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '../generate_models.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateModelFile(
  String fixedFilePath,
  Map<String, String> templates,
) async {
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  var className = "";
  String? collectionPath;
  var parameters = <String, TypeCode>{};

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotation field .
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

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotated class.
  Future<void> onAnnotatedClass(String _, String parentClassName) async {
    // Create the actual values to replace the placeholders with.
    className = className.isEmpty ? "${parentClassName}Model" : className;
    final classFileName = getFileName(fixedFilePath);

    // Replace placeholders with the actual values.
    final template = templates.values.first;
    final output = replaceAllData(
      template,
      {
        "___PARENT_CLASS___": parentClassName,
        "___CLASS___": className,
        "___CLASS_FILE_NAME___": classFileName,
        "___COLLECTION_PATH___": collectionPath,
        ..._replacements(parameters),
      },
    );

    // Get the output file path.
    final outputFilePath = () {
      final classFileDirPath = getDirPath(fixedFilePath);
      final classKey = getFileNameWithoutExtension(classFileName);
      final outputFileName = "$classKey.g.dart";
      return p.join(classFileDirPath, outputFileName);
    }();

    // Write the generated Dart file.
    await writeFile(outputFilePath, output);

    // Format the generated Dart file.
    await fmtDartFile(outputFilePath);

    // Log the generated file.
    Here(#debug).debugLog("Generated $className in $outputFilePath");
  }

  // ---------------------------------------------------------------------------

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    classAnnotations: {"GenerateModel"},
    onAnnotatedClass: onAnnotatedClass,
    onClassAnnotationField: onClassAnnotationField,
  );
}
