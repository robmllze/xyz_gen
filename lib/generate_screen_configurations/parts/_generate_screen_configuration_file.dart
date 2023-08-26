// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '../generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateScreenConfigurationFile(
  String fixedFilePath,
  Map<String, String> templates,
) async {
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  var isOnlyAccessibleIfSignedInAndVerified = false;
  var isOnlyAccessibleIfSignedIn = false;
  var isOnlyAccessibleIfSignedOut = false;
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
      case "isOnlyAccessibleIfSignedInAndVerified":
        isOnlyAccessibleIfSignedInAndVerified = fieldValue.toBoolValue() ?? false;
        break;
      case "isOnlyAccessibleIfSignedIn":
        isOnlyAccessibleIfSignedIn = fieldValue.toBoolValue() ?? false;
        break;
      case "isOnlyAccessibleIfSignedOut":
        isOnlyAccessibleIfSignedOut = fieldValue.toBoolValue() ?? false;
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
    final classFileName = getFileName(fixedFilePath);
    final classFileDirPath = getDirPath(fixedFilePath);
    final classKey = getFileNameWithoutExtension(classFileName);
    final screenKey = className.toSnakeCase();
    final configurationClassName = "${className}Configuration";
    final screenSegment = screenKey.replaceAll("screen_", "");
    final screenPath = "/$screenSegment";
    final screenSegmentKey = screenSegment.toUpperCase();
    final la0 = isOnlyAccessibleIfSignedInAndVerified;
    final la1 = isOnlyAccessibleIfSignedIn;
    final la2 = isOnlyAccessibleIfSignedOut;
    final la3 = isOnlyAccessibleIfSignedInAndVerified &&
        !isOnlyAccessibleIfSignedIn &&
        !isOnlyAccessibleIfSignedOut;
    final la4 = isRedirectable == false;
    final outputFileName = "$classKey.g.dart";
    final outputFilePath = p.join(classFileDirPath, outputFileName);

    // Replace placeholders with the actual values.
    final template = templates.values.first;
    final output = replaceAllData(
      template,
      {
        "___CLASS___": className,
        "___CONFIGURATION_CLASS___": configurationClassName,
        "___CLASS_FILE___": classFileName,
        "___SCREEN_KEY___": screenKey,
        "___SCREEN_SEGMENT___": screenSegment,
        "___SCREEN_SEGMENT_KEY___": screenSegmentKey,
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
    printGreen("Generated `$configurationClassName` in `$outputFilePath`");
  }

  // ---------------------------------------------------------------------------

  // Analyze the annotated class and generate the screen configuration file.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    classAnnotations: {"GenerateScreenConfiguration"},
    onAnnotatedClass: onAnnotatedClass,
    onClassAnnotationField: onClassAnnotationField,
  );
}
