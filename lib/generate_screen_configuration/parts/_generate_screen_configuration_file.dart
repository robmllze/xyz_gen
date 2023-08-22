// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: constant_identifier_names, avoid_print

part of '../generate_screen_configuration.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _ANNOTATION_NAME = "GenerateScreenConfiguration";
const _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED = "isOnlyAccessibleIfSignedInAndVerified";
const _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN = "isOnlyAccessibleIfSignedIn";
const _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT = "isOnlyAccessibleIfSignedOut";
const _K_IS_REDIRECTABLE = "isRedirectable";
const _K_INTERNAL_PARAMETERS = "internalParameters";
const _K_QUERY_PARAMETERS = "queryParameters";
const _K_PATH_SEGMENTS = "pathSegments";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates the boiler-plate code for the annotated screen class [fixedFilePath]
Future<void> _generateScreenConfigurationFile(
  String fixedFilePath,
  String template,
) async {
  var className = "";
  var isOnlyAccessibleIfSignedInAndVerified = false;
  var isOnlyAccessibleIfSignedIn = false;
  var isOnlyAccessibleIfSignedOut = false;
  bool? isRedirectable;
  var internalParameters = const <String, String>{};
  var queryParameters = const <String>{};
  var pathSegments = const <String>[];

  void onField(
    String name,
    DartObject object,
  ) {
    switch (name) {
      case _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED:
        isOnlyAccessibleIfSignedInAndVerified = object.toBoolValue() ?? false;
        break;
      case _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN:
        isOnlyAccessibleIfSignedIn = object.toBoolValue() ?? false;
        break;
      case _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT:
        isOnlyAccessibleIfSignedOut = object.toBoolValue() ?? false;
        break;
      case _K_IS_REDIRECTABLE:
        isRedirectable = object.toBoolValue();
        break;
      case _K_INTERNAL_PARAMETERS:
        internalParameters = object
                .toMapValue()
                ?.map((final k, final v) => MapEntry(k?.toStringValue(), v?.toStringValue()))
                .nonNulls ??
            const {};
        break;
      case _K_QUERY_PARAMETERS:
        queryParameters = object.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? {};
        break;
      case _K_PATH_SEGMENTS:
        pathSegments = object.toListValue()?.map((e) => e.toStringValue()).nonNulls.toList() ?? [];
        break;
    }
  }

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    annotationName: _ANNOTATION_NAME,
    fieldNames: {
      _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED,
      _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN,
      _K_IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT,
      _K_IS_REDIRECTABLE,
      _K_INTERNAL_PARAMETERS,
      _K_QUERY_PARAMETERS,
      _K_PATH_SEGMENTS,
    },
    onClass: (e) {
      print("- Generating screen configuration for $e");
      className = e;
    },
    onField: onField,
  );

  // Create the actual values to replace the placeholders with.
  final classFileName = getFileName(fixedFilePath);
  final classFileDirPath = getDirPath(fixedFilePath);
  final classKey = getFileNameWithoutExtension(classFileName);
  final screenKey = className.toSnakeCase();
  final screenSegment = screenKey.replaceAll("screen_", "");
  final screenPath = "/$screenSegment";
  final segmentKey = screenSegment.toUpperCase();
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
  final output = replaceAllData(
    template,
    {
      "___CLASS___": className,
      "___CONFIGURATION___": "${className}Configuration",
      "___CLASS_FILE___": classFileName,
      "___SCREEN_KEY___": screenKey,
      "___SEGMENT___": screenSegment,
      "___SEGMENT_KEY___": segmentKey,
      "___PATH___": screenPath,
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
}
