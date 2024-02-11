//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  Map<String, String> templates,
) async {
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  var className = "";
  final fields = <String, TypeCode>{};
  var shouldInherit = false;
  var inheritanceConstructor = "";
  var keyStringCaseType = StringCaseType.LOWER_SNAKE_CASE;

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotation field.
  void onClassAnnotationField(String fieldName, DartObject fieldValue) {
    switch (fieldName) {
      case "className":
        className = fieldValue.toStringValue() ?? "";
        break;
      case "fields":
        fields.addAll(
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
      case "shouldInherit":
        shouldInherit = fieldValue.toBoolValue() ?? false;
        break;
      case "inheritanceConstructor":
        inheritanceConstructor = fieldValue.toStringValue() ?? "";
        break;
      case "keyStringCase":
        keyStringCaseType =
            nameToStringCaseType(fieldValue.toStringValue()) ?? StringCaseType.LOWER_SNAKE_CASE;
        break;
    }
  }

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotated member.
  Future<void> onAnnotatedMember(
    String memberAnnotationName,
    String memberName,
    String memberType,
  ) async {
    if (memberAnnotationName == "Field") {
      fields.addAll({
        memberName: TypeCode(memberType),
      });
    }
  }

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotated class.
  Future<void> onAnnotatedClass(String _, String superClassName) async {
    // Decide on the class name.
    final a = superClassName.replaceFirst(RegExp(r"^_+"), "");
    final b = a != superClassName ? a : "${superClassName}Model";
    className = className.isEmpty ? b : className;

    // Get the class file name from the file path.
    final classFileName = getBaseName(fixedFilePath);

    // Replace placeholders with the actual values.
    final template = templates.values.first;
    final output = replaceAllData(
      template,
      {
        "___SUPER_CLASS___": shouldInherit ? superClassName : "Model",
        "___SUPER_CONSTRUCTOR___": shouldInherit
            ? inheritanceConstructor.isNotEmpty
                ? ": super.$inheritanceConstructor()"
                : ": super()"
            : "",
        "___CLASS___": className,
        "___CLASS_FILE_NAME___": classFileName,
        ..._replacements(fields, keyStringCaseType),
      },
    );

    // Get the output file path.
    final outputFilePath = () {
      final classFileDirPath = getDirPath(fixedFilePath);
      final classKey = getFileNameWithoutExtension(classFileName);
      final outputFileName = "_$classKey.g.dart";
      return p.join(classFileDirPath, outputFileName);
    }();

    // Write the generated Dart file.
    await writeFile(outputFilePath, output);

    // Format the generated Dart file.
    await fmtDartFile(outputFilePath);

    // Log the generated file.
    printGreen("Generated `$className` in `${getBaseName(outputFilePath)}`");
  }

  // ---------------------------------------------------------------------------

  // Analyze the annotated class and generate the model file.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    collection: collection,
    classAnnotations: {"GenerateModel"},
    onAnnotatedClass: onAnnotatedClass,
    onClassAnnotationField: onClassAnnotationField,
    memberAnnotations: {"Field"},
    onAnnotatedMember: onAnnotatedMember,
  );
}
