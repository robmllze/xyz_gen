//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<Set<String>> _generateScreenConfigurationFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  Map<String, String> templates,
) async {
  // ---------------------------------------------------------------------------

  // Create variables to hold the annotation's field values.
  var path = "";
  var isAccessibleOnlyIfLoggedInAndVerified = false;
  var isAccessibleOnlyIfLoggedIn = false;
  var isAccessibleOnlyIfLoggedOut = false;
  var isRedirectable = false;
  var internalParameters = const <String, String>{};
  var queryParameters = const <String>{};
  var pathSegments = const <String>[];
  var navigationControlWidget = "null";
  var defaultTitle = "...";
  var makeup = "null";

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotation field.
  void onClassAnnotationField(
    String fieldName,
    DartObject fieldValue,
  ) {
    switch (fieldName) {
      case "path":
        path = fieldValue.toStringValue() ?? "";
      case "isAccessibleOnlyIfLoggedInAndVerified":
        isAccessibleOnlyIfLoggedInAndVerified = fieldValue.toBoolValue() ?? false;
        break;
      case "isAccessibleOnlyIfLoggedIn":
        isAccessibleOnlyIfLoggedIn = fieldValue.toBoolValue() ?? false;
        break;
      case "isAccessibleOnlyIfLoggedOut":
        isAccessibleOnlyIfLoggedOut = fieldValue.toBoolValue() ?? false;
        break;
      case "isRedirectable":
        isRedirectable = fieldValue.toBoolValue() ?? false;
        break;
      case "internalParameters":
        internalParameters = fieldValue
                .toMapValue()
                ?.map(
                  (final k, final v) => MapEntry(k?.toStringValue(), v?.toStringValue()),
                )
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
      case "navigationControlWidget":
        navigationControlWidget =
            fieldValue.toStringValue()?.nullIfEmpty ?? navigationControlWidget;
        break;
      case "defaultTitle":
        defaultTitle = fieldValue.toStringValue()?.nullIfEmpty ?? defaultTitle;
        break;
      case "makeup":
        makeup = fieldValue.toStringValue()?.nullIfEmpty ?? makeup;
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
    final screenKeyName = screenKey.replaceAll("screen_", "");
    final screenSegment = joinAll(
      [
        (path.isNotEmpty && path.startsWith(RegExp(r"[\\/]")) ? path.substring(1) : path)
            .replaceAll("screen_", ""),
        screenKeyName,
      ],
    );
    final screenPath = "/$screenSegment";
    assert(
      !isAccessibleOnlyIfLoggedInAndVerified || !isAccessibleOnlyIfLoggedIn,
      "Cannot set both `isAccessibleOnlyIfLoggedInAndVerified` and `isAccessibleOnlyIfLoggedIn` to `true`.",
    );
    assert(
      !isAccessibleOnlyIfLoggedInAndVerified || !isAccessibleOnlyIfLoggedOut,
      "Cannot set both `isAccessibleOnlyIfLoggedInAndVerified` and `isAccessibleOnlyIfLoggedOut` to `true`.",
    );
    assert(
      !isAccessibleOnlyIfLoggedIn || !isAccessibleOnlyIfLoggedOut,
      "Cannot set both `isAccessibleOnlyIfLoggedIn` and `isAccessibleOnlyIfLoggedOut` to `true`.",
    );
    final isAlwaysAccessible = (!isAccessibleOnlyIfLoggedInAndVerified &&
        !isAccessibleOnlyIfLoggedIn &&
        !isAccessibleOnlyIfLoggedOut);
    final outputFileName = "_$classKey.g.dart";
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
        "___IS_ACCESSIBLE_ONLY_IF_LOGGED_IN_AND_VERIFIED___": isAccessibleOnlyIfLoggedInAndVerified,
        "___IS_ACCESSIBLE_ONLY_IF_LOGGED_IN___": isAccessibleOnlyIfLoggedIn,
        "___IS_ACCESSIBLE_ONLY_IF_LOGGED_OUT___": isAccessibleOnlyIfLoggedOut,
        "___IS_ALWAYS_ACCESSIBLE___": isAlwaysAccessible,
        "___IS_REDIRECTABLE___": isRedirectable,
        "___IP0___": _ip0(internalParameters),
        "___IP1___": _ip1(internalParameters),
        "___IP3___": _ip3(internalParameters),
        "___QP0___": _qp0(queryParameters),
        "___QP1___": _qp1(queryParameters),
        "___QP3___": _qp3(queryParameters),
        "___PS0___": _ps0(pathSegments),
        "___PS1___": _ps1(pathSegments),
        "___PS3___": _ps3(pathSegments),
        "___NAVIGATION_CONTROLS_WIDGET___": navigationControlWidget,
        "___DEFAULT_TITLE___": defaultTitle,
        "___MAKEUP___": makeup,
      }.nonNulls,
    );

    // Write the generated Dart file.
    await writeFile(outputFilePath, output);

    // Format the generated Dart file.
    await fmtDartFile(outputFilePath);

    // Log the generated file.
    printGreen(
      "Generated `$configurationClassName` in `${getBaseName(outputFilePath)}`",
    );
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
