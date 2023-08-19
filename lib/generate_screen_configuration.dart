// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: constant_identifier_names, avoid_print

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils.dart';

import 'utils/file_io.dart';
import 'utils/analyze_source_classes.dart';
import 'utils/helpers.dart';
import 'package:path/path.dart' as p;

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
Future<void> generateScreenConfigurationFile(
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip0(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final fieldKey = fieldName.toSnakeCase();
    final nullable = fieldType.endsWith("?");
    final nullCheck = nullable ? "" : "!";
    final t = nullable ? fieldType.substring(0, fieldType.length - 1) : fieldType;
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the **internal parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "$fieldType get $fieldName => super.arguments<$t>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

//

String _ip1(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final required = fieldType.endsWith("?") ? "" : "required ";
    return "$required$fieldType $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

//

String _ip2(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final ifNotNull = fieldType.endsWith("?") ? "if ($fieldName != null) " : "";
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return "$ifNotNull $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "$_K_INTERNAL_PARAMETERS: {${a.join("\n")}}," : "";
}

//

String _qp0(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    final fieldKey = fieldName.toSnakeCase();
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the URI **query parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "String? get $fieldName => super.arguments<String>($fieldK);",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

//

String _qp1(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    return "String? $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

//

String _qp2(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return "if ($fieldName != null) $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "$_K_QUERY_PARAMETERS: {${a.join("\n")}}," : "";
}

//

String _ps0(List<String> pathSegments) {
  var n = 0;
  final a = pathSegments.map((final l) {
    final fieldName = l;
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = ${++n};",
      "/// Returns the URI **path segment** at position `$n` AKA the value",
      "/// corresponding to the key `$n` or [$fieldK].",
      "String? get $fieldName => super.arguments<String>($fieldK)?.nullIfEmpty;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

//

String _ps1(List<String> pathSegments) {
  final a = pathSegments.map((final l) {
    final fieldName = l;
    return "String? $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

//

String _ps2(List<String> pathSegments) {
  final a = pathSegments.map((final l) {
    final fieldName = l;
    return "$fieldName ?? \"\",";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "$_K_PATH_SEGMENTS: [${a.join("\n")}]," : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateScreenConfiguration {
  /// Set to `true` to ensure the screen can only be accessed if the current
  /// user is signed in and verified.
  final bool isOnlyAccessibleIfSignedInAndVerified;

  /// Set to `true` to ensure the screen can only be accessed if the current
  /// user is signed in (and not necessarily verified).
  final bool isOnlyAccessibleIfSignedIn;

  /// Set to `true` to ensure the screen can only be accessed if there are no
  /// currently signed-in users.
  final bool isOnlyAccessibleIfSignedOut;

  /// Set to `false` to ensure that the screen is not redirectable.
  ///
  /// Example:
  ///
  /// If your screen's route is `/delete_account`, normally you can access it
  /// by typing https://medikienct.app/delete_account in the browser. This will
  /// start the app and redirect to "/delete_account". This can be disabled
  /// by setting [isRedirectable] to `false`.
  final bool? isRedirectable;

  /// ...
  final Map<String, String> internalParameters;

  /// ...
  final Set<String> queryParameters;

  /// ...
  final List<String> pathSegments;

  /// Generates boiler-plate code for the annotated screen class to make it
  /// accessible.
  const GenerateScreenConfiguration({
    this.isOnlyAccessibleIfSignedInAndVerified = false,
    this.isOnlyAccessibleIfSignedIn = false,
    this.isOnlyAccessibleIfSignedOut = false,
    this.isRedirectable,
    this.internalParameters = const {},
    this.queryParameters = const {},
    this.pathSegments = const [],
  });
}
