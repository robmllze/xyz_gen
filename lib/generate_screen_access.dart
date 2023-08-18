// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: constant_identifier_names

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils.dart';

import 'utils/file_io.dart';
import 'utils/find_files.dart';
import 'utils/analyze_source_classes.dart';
import 'utils/get_templates_from_md.dart';
import 'utils/helpers.dart';
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED = "isOnlyAccessibleIfSignedInAndVerified";
const IS_ONLY_ACCESSIBLE_IF_SIGNED_IN = "isOnlyAccessibleIfSignedIn";
const IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT = "isOnlyAccessibleIfSignedOut";
const IS_REDIRECTABLE = "isRedirectable";
const INTERNAL_PARAMETERS = "internalParameters";
const QUERY_PARAMETERS = "queryParameters";
const PATH_SEGMENTS = "pathSegments";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenAccess(
  String rootDirPath, {
  Set<String> pathPatterns = const {},
  bool deleteGeneratedFiles = false,
}) async {
  final templates = await getTemplatesFromMd("./templates/screen_templates.md");
  if (deleteGeneratedFiles) {
    await deleteGeneratedFiles1(rootDirPath, pathPatterns);
  }
  await findFiles(
    rootDirPath: rootDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (final dirName, final folderName, final filePath) async {
      // Generate if the file name matches the pattern "screen*.dart".
      final a = isMatchingFileName(filePath, "screen", "dart").$1;
      final b = isSourceDartFilePath(filePath);
      if (a && b) {
        await _generate(filePath, templates);
      }
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generate(
  String fixedFilePath,
  List<String> templates,
) async {
  String? className;
  bool? isOnlyAccessibleIfSignedInAndVerified;
  bool? isOnlyAccessibleIfSignedIn;
  bool? isOnlyAccessibleIfSignedOut;
  bool? isRedirectable;
  Map<String, String>? internalParameters;
  Set<String>? queryParameters;
  List<String>? pathSegments;

  void onField(
    String classDisplayName,
    String fieldName,
    DartObject object,
  ) {
    className = classDisplayName;
    switch (fieldName) {
      case IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED:
        isOnlyAccessibleIfSignedInAndVerified = object.toBoolValue();
      case IS_ONLY_ACCESSIBLE_IF_SIGNED_IN:
        isOnlyAccessibleIfSignedIn = object.toBoolValue();
      case IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT:
        isOnlyAccessibleIfSignedOut = object.toBoolValue();
      case IS_REDIRECTABLE:
        isRedirectable = object.toBoolValue();
      case INTERNAL_PARAMETERS:
        internalParameters = object
            .toMapValue()
            ?.map((final k, final v) => MapEntry(k?.toStringValue(), v?.toStringValue()))
            .nonNulls;
      case QUERY_PARAMETERS:
        queryParameters = object.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? {};
      case PATH_SEGMENTS:
        pathSegments = object.toListValue()?.map((e) => e.toStringValue()).nonNulls.toList() ?? [];
        break;
    }
  }

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    annotationDisplayName: "GenerateScreenAccess",
    fieldNames: {
      IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED,
      IS_ONLY_ACCESSIBLE_IF_SIGNED_IN,
      IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT,
      IS_REDIRECTABLE,
      INTERNAL_PARAMETERS,
      QUERY_PARAMETERS,
      PATH_SEGMENTS,
    },
    onField: onField,
  );

  // Create the actual values to replace the placeholders with.
  final classFileName = getFileName(fixedFilePath);
  final classFileDirPath = getDirPath(fixedFilePath);
  final classKey = getFileNameWithoutExtension(classFileName);
  final screenKey = className!.toSnakeCase();
  final screenSegment = screenKey.replaceAll("screen_", "");
  final screenPath = "/$screenSegment";
  final segmentKey = screenSegment.toUpperCase();
  final la0 = isOnlyAccessibleIfSignedInAndVerified!;
  final la1 = isOnlyAccessibleIfSignedIn!;
  final la2 = isOnlyAccessibleIfSignedOut!;
  final la3 = isOnlyAccessibleIfSignedInAndVerified! &&
      !isOnlyAccessibleIfSignedIn! &&
      !isOnlyAccessibleIfSignedOut!;
  final la4 = isRedirectable == false;

  // Iterate though all the templates.
  for (var n = 0; n < templates.length; n++) {
    final template = templates[n];
    final outputFileName = n == 0 ? "$classKey.g.dart" : "${classKey}_$n.g.dart";
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
        "___IP0___": _ip0(internalParameters ?? {}),
        "___IP1___": _ip1(internalParameters ?? {}),
        "___IP2___": _ip2(internalParameters ?? {}),
        "___QP0___": _qp0(queryParameters ?? {}),
        "___QP1___": _qp1(queryParameters ?? {}),
        "___QP2___": _qp2(queryParameters ?? {}),
        "___PS0___": _ps0(pathSegments ?? []),
        "___PS1___": _ps1(pathSegments ?? []),
        "___PS2___": _ps2(pathSegments ?? []),
      }.nonNulls,
    );

    // Write the generated Dart file.
    await writeFile(outputFilePath, output);

    // Format the generated Dart file.
    await fmtDartFile(outputFilePath);
  }
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
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
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
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "$ifNotNull $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "$INTERNAL_PARAMETERS: {${a.join("\n")}}," : "";
}

//

String _qp0(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    final fieldKey = fieldName.toSnakeCase();
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
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
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "if ($fieldName != null) $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "$QUERY_PARAMETERS: {${a.join("\n")}}," : "";
}

//

String _ps0(List<String> pathSegments) {
  var n = 0;
  final a = pathSegments.map((final l) {
    final fieldName = l;
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
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
  return a.isNotEmpty ? "$PATH_SEGMENTS: [${a.join("\n")}]," : "";
}
