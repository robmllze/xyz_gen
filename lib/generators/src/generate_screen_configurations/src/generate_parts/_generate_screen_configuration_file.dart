//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<Set<String>> _generateForFile(
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
        isAccessibleOnlyIfLoggedInAndVerified =
            fieldValue.toBoolValue() ?? false;
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
                  (k, v) => MapEntry(
                    k?.toStringValue()?.nullIfEmpty,
                    v?.toStringValue()?.nullIfEmpty,
                  ),
                )
                .nonNulls ??
            const {};
        break;
      case "queryParameters":
        queryParameters = fieldValue
                .toSetValue()
                ?.map((e) => e.toStringValue()?.nullIfEmpty)
                .nonNulls
                .toSet() ??
            {};
        break;
      case "pathSegments":
        pathSegments = fieldValue
                .toListValue()
                ?.map((e) => e.toStringValue()?.nullIfEmpty)
                .nonNulls
                .toList() ??
            [];
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
    final screenSegment = p.joinAll(
      [
        (path.isNotEmpty && path.startsWith(RegExp(r"[\\/]"))
                ? path.substring(1)
                : path)
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
        "___SCREEN_CONST_KEY___": screenConstKey,
        "___SCREEN_SEGMENT___": screenSegment,
        "___SCREEN_PATH___": screenPath,
        "___IS_ACCESSIBLE_ONLY_IF_LOGGED_IN_AND_VERIFIED___":
            isAccessibleOnlyIfLoggedInAndVerified,
        "___IS_ACCESSIBLE_ONLY_IF_LOGGED_IN___": isAccessibleOnlyIfLoggedIn,
        "___IS_ACCESSIBLE_ONLY_IF_LOGGED_OUT___": isAccessibleOnlyIfLoggedOut,
        "___IS_ALWAYS_ACCESSIBLE___": isAlwaysAccessible,
        "___IS_REDIRECTABLE___": isRedirectable,
        "___IP0___": _ip0(internalParameters),
        "___IP1___": _ip1(internalParameters),
        "___IP2___": _ip2(internalParameters),
        "___QP0___": _qp0(queryParameters),
        "___QP1___": _qp1(queryParameters),
        "___QP2___": _qp2(queryParameters),
        "___PS0___": _ps0(pathSegments),
        "___PS1___": _ps1(pathSegments),
        "___PS2___": _ps2(pathSegments),
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip0(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((e) {
    final fieldName = e.key;
    final fieldType = e.value;
    final fieldKey = fieldName.toSnakeCase();
    final nullable = fieldType.endsWith("?");
    final nullCheck = nullable ? "" : "!";
    final t =
        nullable ? fieldType.substring(0, fieldType.length - 1) : fieldType;
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the **internal parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "$fieldType get $fieldName => super.arg<$t>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String _ip1(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((e) {
    final fieldName = e.key;
    final fieldType = e.value;
    final required = fieldType.endsWith("?") ? "" : "required ";
    return "$required$fieldType $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String _ip2(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((e) {
    final fieldName = e.key;
    final fieldType = e.value;
    final ifNotNull = fieldType.endsWith("?") ? "if ($fieldName != null) " : "";
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "$ifNotNull $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String _qp0(Set<String> queryParameters) {
  final a = queryParameters.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName =
        nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    final fieldKey = fieldName.toSnakeCase();
    final nullCheck = nullable ? "" : "!";
    final nullableCheck = nullable ? "?" : "";
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the URI **query parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "String$nullableCheck get $fieldName => super.arg<String>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String _qp1(Set<String> queryParameters) {
  return _ps1(queryParameters.toList());
}

String _qp2(Set<String> queryParameters) {
  return _ps2(queryParameters.toList());
}

String _ps0(List<String> pathSegments) {
  var n = 0;
  final a = pathSegments.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName =
        nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    final nullCheck = nullable ? "" : "!";
    final nullableCheck = nullable ? "?" : "";
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = ${++n};",
      "/// Returns the URI **path segment** at position `$n` AKA the value",
      "/// corresponding to the key `$n` or [$fieldK].",
      "String$nullableCheck get $fieldName => super.arg<String>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String _ps1(List<String> pathSegments) {
  final a = pathSegments.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName =
        nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    return "${nullable ? "String?" : "required String"} $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String _ps2(List<String> pathSegments) {
  final a = pathSegments.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName =
        nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "${nullable ? "if ($fieldName != null) " : ""}$fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}
