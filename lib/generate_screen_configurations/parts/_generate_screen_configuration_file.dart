// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '../generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<Set<String>> _generateScreenConfigurationFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  Map<String, String> templates,
) async {
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  bool? isOnlyAccessibleIfLoggedInAndVerified;
  bool? isOnlyAccessibleIfLoggedIn;
  bool? isOnlyAccessibleIfLoggedOut;
  bool? isRedirectable;
  var internalParameters = const <String, String>{};
  var queryParameters = const <String>{};
  var pathSegments = const <String>[];

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotation field.
  void onClassAnnotationField(
    String fieldName,
    DartObject fieldValue,
  ) {
    switch (fieldName) {
      case "isOnlyAccessibleIfLoggedInAndVerified":
        isOnlyAccessibleIfLoggedInAndVerified = fieldValue.toBoolValue();
        break;
      case "isOnlyAccessibleIfLoggedIn":
        isOnlyAccessibleIfLoggedIn = fieldValue.toBoolValue();
        break;
      case "isOnlyAccessibleIfLoggedOut":
        isOnlyAccessibleIfLoggedOut = fieldValue.toBoolValue();
        break;
      case "isRedirectable":
        isRedirectable = fieldValue.toBoolValue();
        break;
      case "internalParameters":
        internalParameters = fieldValue
                .toMapValue()
                ?.map((final k, final v) => MapEntry(k?.toStringValue(), v?.toStringValue()))
                .nonNulls ??
            const {};
        break;
      case "queryParameters":
        queryParameters =
            fieldValue.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? {};
        break;
      case "pathSegments":
        pathSegments =
            fieldValue.toListValue()?.map((e) => e.toStringValue()).nonNulls.toList() ?? [];
        break;
    }
  }

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotated class.
  Future<void> onAnnotatedClass(String _, String className) async {
    // Create the actual values to replace the placeholders with.
    final classFileName = getBaseName(fixedFilePath);
    final classFileDirPath = getDirPath(fixedFilePath);
    final classKey = getFileNameWithoutExtension(classFileName);
    final screenKey = className.toSnakeCase();
    final screenConstKey = screenKey.toUpperCase();
    final configurationClassName = "${className}Configuration";
    final screenSegment = screenKey.replaceAll("screen_", "");
    final screenPath = "/$screenSegment";
    final la0 = isOnlyAccessibleIfLoggedInAndVerified == true;
    final la1 = isOnlyAccessibleIfLoggedIn == true;
    final la2 = isOnlyAccessibleIfLoggedOut == true;
    final la3 = isOnlyAccessibleIfLoggedInAndVerified == null &&
        isOnlyAccessibleIfLoggedIn == null &&
        isOnlyAccessibleIfLoggedOut == null;
    final la4 = isRedirectable == false;
    final outputFileName = "$classKey.g.dart";
    final outputFilePath = join(classFileDirPath, outputFileName);

    // Replace placeholders with the actual values.
    final template = templates.values.first;
    final output = replaceAllData(
      template,
      {
        "___CLASS___": className,
        "___CONFIGURATION_CLASS___": configurationClassName,
        "___CLASS_FILE___": classFileName,
        "___SCREEN_KEY___": screenKey,
        "___SCREEN_CONST_KEY___": screenConstKey,
        "___SCREEN_SEGMENT___": screenSegment,
        "___SCREEN_PATH___": screenPath,
        "___LA0___": la0,
        "___LA1___": la1,
        "___LA2___": la2,
        "___LA3___": la3,
        "___LA4___": la4,
        "___IP0___": _ip0(internalParameters),
        "___IP1___": _ip1(internalParameters),
        "___IP2___": _ip2(internalParameters),
        "___QP0___": _qp0(queryParameters),
        "___QP1___": _qp1(queryParameters),
        "___QP2___": _qp2(queryParameters),
        "___PS0___": _ps0(pathSegments),
        "___PS1___": _ps1(pathSegments),
        "___PS2___": _ps2(pathSegments),
      }.nonNulls,
    );

    // Write the generated Dart file.
    await writeFile(outputFilePath, output);

    // Format the generated Dart file.
    await fmtDartFile(outputFilePath);

    // Log the generated file.
    printGreen("Generated `$configurationClassName` in `${getBaseName(outputFilePath)}`");
  }

  // ---------------------------------------------------------------------------

  final classNames = <String>{};

  // Analyze the annotated class and generate the screen configuration file.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    collection: collection,
    classAnnotations: {"GenerateScreenConfiguration"},
    onAnnotatedClass: (final classAnnotationName, final className) async {
      await onAnnotatedClass(classAnnotationName, className);
      // Get all the class names to use later.
      classNames.add(className);
    },
    onClassAnnotationField: onClassAnnotationField,
  );

  // Return the class names to use later.
  return classNames;
}
